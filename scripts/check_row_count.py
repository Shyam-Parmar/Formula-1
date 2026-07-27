"""Compare row counts between Supabase tables and processed CSVs."""

# =========================
# Libraries
# =========================
import os
from pathlib import Path

import pandas as pd
from dotenv import load_dotenv
from supabase import create_client

# =========================
# Constants
# =========================
PROJECT_ROOT = Path(__file__).resolve().parent.parent
PROCESSED_PATH = PROJECT_ROOT / "data" / "processed"

TABLES = [
    "circuits",
    "constructors",
    "constructor_results",
    "constructor_standings",
    "drivers",
    "driver_standings",
    "lap_times",
    "pit_stops",
    "qualifying",
    "races",
    "results",
    "seasons",
    "sprint_results",
    "status",
]

# =========================
# Functions
# =========================
def get_supabase_count(client, table_name: str) -> int:
    response = client.table(table_name).select("*", count="exact", head=True).execute()
    return response.count or 0


def get_csv_count(table_name: str) -> int:
    csv_path = PROCESSED_PATH / f"{table_name}.csv"
    if not csv_path.exists():
        return 0
    return sum(1 for _ in open(csv_path, encoding="utf-8")) - 1  # subtract header row


def print_comparison(rows: list[dict]) -> None:
    name_width = max(len(r["table"]) for r in rows) + 2
    header = f"{'Table':<{name_width}}{'Supabase':>12}{'CSV':>12}{'Difference':>12}"
    print(header)
    print("-" * len(header))

    for r in rows:
        diff = r["csv"] - r["supabase"]
        print(f"{r['table']:<{name_width}}{r['supabase']:>12,}{r['csv']:>12,}{diff:>12,}")

# =========================
# Main
# =========================
def main() -> None:
    load_dotenv()
    url = os.environ["SUPABASE_URL"]
    key = os.environ["SUPABASE_SERVICE_ROLE_KEY"]
    client = create_client(url, key)

    rows = []
    for table_name in TABLES:
        supabase_count = get_supabase_count(client, table_name)
        csv_count = get_csv_count(table_name)
        rows.append({"table": table_name, "supabase": supabase_count, "csv": csv_count})

    print_comparison(rows)


if __name__ == "__main__":
    main()