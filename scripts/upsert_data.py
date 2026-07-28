"""Load processed F11 CSVs into Supabase, upserting on primary key."""

# =========================
# Libraries
# =========================
import os
import math
from pathlib import Path
from datetime import date

import pandas as pd
import numpy as np
from dotenv import load_dotenv
from supabase import create_client


# =========================
# Constants
# =========================
PROJECT_ROOT = Path(__file__).resolve().parent.parent
PROCESSED_PATH = PROJECT_ROOT / "data" / "processed"

BATCH_SIZE = 500
CURRENT_SEASON = date.today().year

# Table load order matters: parents before children, so FK targets exist first
TABLE_CONFIG = {
    # Small reference tables — always loaded in full
    "seasons":       {"pk": ["year"]},
    "circuits":      {"pk": ["circuit_id"]},
    "drivers":       {"pk": ["driver_id"]},
    "constructors":  {"pk": ["constructor_id"]},
    "status":        {"pk": ["status_id"]},
    "races":         {"pk": ["race_id"]},

    # Large race-level tables — filtered to current season on weekly runs
    "results":                {"pk": ["result_id"], "season_filter": True},
    "qualifying":              {"pk": ["qualify_id"], "season_filter": True},
    "sprint_results":          {"pk": ["result_id"], "season_filter": True},
    "lap_times":               {"pk": ["race_id", "driver_id", "lap"], "season_filter": True},
    "pit_stops":               {"pk": ["race_id", "driver_id", "stop"], "season_filter": True},
    "driver_standings":        {"pk": ["driver_standings_id"], "season_filter": True},
    "constructor_standings":   {"pk": ["constructor_standings_id"], "season_filter": True},
    "constructor_results":     {"pk": ["constructor_results_id"], "season_filter": True},
}


# =========================
# Functions
# =========================
def clean_value(value):
    """Convert pandas/numpy types to plain Python types, and NaN to None."""
    if value is None:
        return None
    if isinstance(value, (np.integer,)):
        return int(value)
    if isinstance(value, (np.floating,)):
        return None if math.isnan(value) else float(value)
    if isinstance(value, float) and math.isnan(value):
        return None
    try:
        if pd.isna(value):
            return None
    except (TypeError, ValueError):
        pass
    return value


def load_csv(table_name: str) -> pd.DataFrame:
    csv_path = PROCESSED_PATH / f"{table_name}.csv"
    return pd.read_csv(csv_path)


def filter_to_current_season(df: pd.DataFrame, race_ids_this_season: set) -> pd.DataFrame:
    if "race_id" in df.columns:
        return df[df["race_id"].isin(race_ids_this_season)]
    return df


def to_records(df: pd.DataFrame) -> list[dict]:
    records = df.to_dict(orient="records")
    return [{k: clean_value(v) for k, v in row.items()} for row in records]


def upsert_table(client, table_name: str, records: list[dict], pk_cols: list[str]) -> None:
    if not records:
        print(f" {table_name}: nothing to load")
        return

    on_conflict = ",".join(pk_cols)
    total = len(records)

    for i in range(0, total, BATCH_SIZE):
        batch = records[i:i + BATCH_SIZE]
        client.table(table_name).upsert(batch, on_conflict = on_conflict).execute()
        print(f" {table_name}: {min(i + BATCH_SIZE, total)}/{total}")


# =========================
# Main
# =========================
def main() -> None:
    load_dotenv()
    url = os.environ["SUPABASE_URL"]
    key = os.environ["SUPABASE_SERVICE_ROLE_KEY"]
    client = create_client(url, key)

    # Figure out which race_ids belong to the current season, for filtering large tables
    races_df = load_csv("races")
    race_ids_this_season = set(races_df.loc[races_df["year"] == CURRENT_SEASON, "race_id"])
    print(f"Current season: {CURRENT_SEASON} ({len(race_ids_this_season)} races)")

    for table_name, config in TABLE_CONFIG.items():
        print(f"Loading {table_name}...")
        df = load_csv(table_name)

        if config.get("season_filter"):
            df = filter_to_current_season(df, race_ids_this_season)

        records = to_records(df)
        upsert_table(client, table_name, records, config["pk"])

    print("Done!")

if __name__ == "__main__":
    main()