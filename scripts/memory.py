#!/usr/bin/env python3
"""Bounded readers and calendar-based archiving for Markdown memory logs."""

from __future__ import annotations

import argparse
import calendar
import datetime as dt
import os
import re
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path


LOGS = {
    "trade": ("TRADE-LOG.md", "Trade Log", "month"),
    "research": ("RESEARCH-LOG.md", "Research Log", "month"),
    "weekly": ("WEEKLY-REVIEW.md", "Weekly Review", "quarter"),
}
ISO_DATE = re.compile(r"\b(20\d{2})-(\d{2})-(\d{2})\b")
LEGACY_DATE = re.compile(
    r"^#{2,6}\s+(?:Week ending\s+)?"
    r"(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s+(\d{1,2})\b",
    re.IGNORECASE,
)


@dataclass(frozen=True)
class Section:
    date: dt.date
    text: str
    order: int


def project_root() -> Path:
    return Path(__file__).resolve().parent.parent


def heading_date(line: str, as_of: dt.date) -> dt.date | None:
    if not line.startswith("##"):
        return None
    match = ISO_DATE.search(line)
    if match:
        try:
            return dt.date(*(int(part) for part in match.groups()))
        except ValueError:
            return None
    legacy = LEGACY_DATE.search(line)
    if not legacy:
        return None
    month = list(calendar.month_abbr).index(legacy.group(1)[:3].title())
    day = int(legacy.group(2))
    year = as_of.year
    try:
        candidate = dt.date(year, month, day)
    except ValueError:
        return None
    if candidate > as_of + dt.timedelta(days=7):
        candidate = candidate.replace(year=year - 1)
    return candidate


def parse_log(text: str, as_of: dt.date) -> tuple[str, list[Section]]:
    lines = text.splitlines(keepends=True)
    starts: list[tuple[int, dt.date]] = []
    for index, line in enumerate(lines):
        parsed = heading_date(line, as_of)
        if parsed:
            starts.append((index, parsed))
    if not starts:
        return text, []
    prefix = "".join(lines[: starts[0][0]])
    sections = []
    for order, (start, date) in enumerate(starts):
        end = starts[order + 1][0] if order + 1 < len(starts) else len(lines)
        sections.append(Section(date, "".join(lines[start:end]), order))
    return prefix, sections


def archive_key(kind: str, date: dt.date) -> str:
    unit = LOGS[kind][2]
    if unit == "month":
        return date.strftime("%Y-%m")
    return f"{date.year}-Q{((date.month - 1) // 3) + 1}"


def current_key(kind: str, as_of: dt.date) -> str:
    return archive_key(kind, as_of)


def atomic_write(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, temporary = tempfile.mkstemp(prefix=f".{path.name}.", dir=path.parent)
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as handle:
            handle.write(text)
        os.replace(temporary, path)
    except BaseException:
        Path(temporary).unlink(missing_ok=True)
        raise


def archive_one(root: Path, kind: str, as_of: dt.date, dry_run: bool) -> int:
    filename, title, _ = LOGS[kind]
    active = root / "memory" / filename
    prefix, sections = parse_log(active.read_text(encoding="utf-8"), as_of)
    old = [s for s in sections if archive_key(kind, s.date) < current_key(kind, as_of)]
    if not old:
        print(f"{kind}: nothing to archive", file=sys.stderr)
        return 0

    grouped: dict[str, list[Section]] = {}
    for section in old:
        grouped.setdefault(archive_key(kind, section.date), []).append(section)

    planned: dict[Path, str] = {}
    for key, items in grouped.items():
        destination = root / "memory" / "archive" / kind / f"{key}.md"
        existing = destination.read_text(encoding="utf-8") if destination.exists() else ""
        new_items = [item for item in items if item.text.strip() not in existing]
        header = existing or f"# {title} — {key}\n\n"
        planned[destination] = header.rstrip()
        if new_items:
            planned[destination] += "\n\n" + "\n".join(
                item.text.strip() for item in new_items
            )
        planned[destination] += "\n"

    kept = [section for section in sections if section not in old]
    active_text = prefix.rstrip() + "\n"
    if kept:
        active_text += "\n" + "\n".join(section.text.strip() for section in kept) + "\n"

    print(f"{kind}: archive {len(old)} section(s) into {len(planned)} file(s)", file=sys.stderr)
    if not dry_run:
        for path, text in planned.items():
            atomic_write(path, text)
        atomic_write(active, active_text)
    return len(old)


def byte_len(text: str) -> int:
    return len(text.encode("utf-8"))


def trim_bytes(text: str, limit: int) -> str:
    encoded = text.encode("utf-8")
    if len(encoded) <= limit:
        return text
    return encoded[:limit].decode("utf-8", errors="ignore")


def read_bounded(
    root: Path, kind: str, since: dt.date, until: dt.date, max_bytes: int, as_of: dt.date
) -> str:
    filename, _, _ = LOGS[kind]
    active = root / "memory" / filename
    prefix, active_sections = parse_log(active.read_text(encoding="utf-8"), as_of)
    sections = list(active_sections)
    archive_dir = root / "memory" / "archive" / kind
    if archive_dir.exists():
        for path in sorted(archive_dir.glob("*.md")):
            _, archived = parse_log(path.read_text(encoding="utf-8"), as_of)
            sections.extend(archived)

    selected = [section for section in sections if since <= section.date <= until]
    selected.sort(key=lambda section: (section.date, section.order))
    omission_notice = "[memory reader omitted older matching sections to enforce byte limit]\n\n"
    notice = ""
    prefix_budget = min(byte_len(prefix), max_bytes // 2)
    bounded_prefix = trim_bytes(prefix, prefix_budget).rstrip()
    remaining = max_bytes - byte_len(bounded_prefix) - byte_len(omission_notice) - 2
    kept: list[Section] = []
    for section in reversed(selected):
        cost = byte_len(section.text.strip()) + 2
        if cost <= remaining:
            kept.append(section)
            remaining -= cost
        else:
            notice = omission_notice
            break
    kept.reverse()
    body = "\n\n".join(section.text.strip() for section in kept)
    output = bounded_prefix
    if notice or body:
        output = output.rstrip() + "\n\n" + notice + body
    return output.rstrip() + "\n"


def parse_date(value: str) -> dt.date:
    try:
        return dt.date.fromisoformat(value)
    except ValueError as error:
        raise argparse.ArgumentTypeError("expected YYYY-MM-DD") from error


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)

    read_parser = subparsers.add_parser("read", help="read a bounded date range")
    read_parser.add_argument("kind", choices=LOGS)
    read_parser.add_argument("--since", type=parse_date, required=True)
    read_parser.add_argument("--until", type=parse_date, default=dt.date.today())
    read_parser.add_argument("--max-bytes", type=int, default=40_000)

    archive_parser = subparsers.add_parser("archive", help="archive completed periods")
    archive_parser.add_argument("kind", choices=["all", *LOGS], default="all", nargs="?")
    archive_parser.add_argument("--as-of", type=parse_date, default=dt.date.today())
    archive_parser.add_argument("--dry-run", action="store_true")

    args = parser.parse_args()
    root = project_root()
    if args.command == "read":
        if args.since > args.until:
            parser.error("--since cannot be after --until")
        if args.max_bytes < 1_000:
            parser.error("--max-bytes must be at least 1000")
        sys.stdout.write(read_bounded(root, args.kind, args.since, args.until, args.max_bytes, args.until))
        return 0

    kinds = LOGS if args.kind == "all" else [args.kind]
    for kind in kinds:
        archive_one(root, kind, args.as_of, args.dry_run)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
