"""Clean raw F1 CSV files and save them to the processed data folder."""

# =========================
# Libraries
# =========================
import re
from pathlib import Path
import pandas as pd

# =========================
# Constants
# =========================
PROJECT_ROOT = Path(__file__).resolve().parent.parent
RAW_PATH = PROJECT_ROOT / "data" / "raw" / "jtrotman" / "formula-1-race-data" / "versions" / "123"
PROCESSED_PATH = PROJECT_ROOT / "data" / "processed"

# Maps table name to columns that hold time values needing conversion to seconds
TIME_COLUMNS = {
    "lap_times": ["time"],
    "pit_stops": ["time", "duration"],
    "results": ["time", "fastest_lap_time"],
    "qualifying": ["q1", "q2", "q3"],
    "sprint_results": ["time", "fastest_lap_time"],
}

# =========================
# Functions
# =========================
def camel_to_snake(name: str) -> str:
    # First pass catches boundaries like "RaceID" to "Race_ID"
    name = re.sub(r"(.)([A-Z][a-z]+)", r"\1_\2", name)
    # Second pass catches boundaries like "raceId" to "race_Id"
    name = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", name)
    return name.lower()


def time_to_seconds(value) -> float | None:
    if pd.isna(value) or value is None:
        return None

    # Gap times in the source data are prefixed with "+" (e.g. "+1:23.456")
    value = str(value).strip().lstrip("+")
    # "\N" is how the raw CSVs represent missing values
    if value in ("\\N", ""):
        return None

    # Time values come in three formats: h:m:s, m:s, or plain seconds
    parts = value.split(":")
    try:
        if len(parts) == 3:
            h, m, s = parts
            return int(h) * 3600 + int(m) * 60 + float(s)
        if len(parts) == 2:
            m, s = parts
            return int(m) * 60 + float(s)
        return float(parts[0])
    except ValueError:
        # Catches malformed values that don't match any expected time format
        return None


def clean_dataset(df: pd.DataFrame, table_name: str) -> pd.DataFrame:
    df = df.replace(r"\N", None)
    # Only apply time conversion to tables/columns known to contain time strings
    for col in TIME_COLUMNS.get(table_name, []):
        if col in df.columns:
            df[col] = df[col].apply(time_to_seconds)
    df = df.drop_duplicates()
    return df


def clean_file(csv_path: Path, output_dir: Path) -> str:
    table_name = csv_path.stem
    df = pd.read_csv(csv_path)
    df.columns = [camel_to_snake(col) for col in df.columns]
    df = clean_dataset(df, table_name)
    df.to_csv(output_dir / csv_path.name, index=False)
    return table_name

# =========================
# Main
# =========================
def main() -> None:
    PROCESSED_PATH.mkdir(parents=True, exist_ok=True)

    csv_files = sorted(RAW_PATH.glob("*.csv"))
    if not csv_files:
        print(f"No CSV files found in {RAW_PATH}")
        return

    for csv_path in csv_files:
        table_name = clean_file(csv_path, PROCESSED_PATH)
        print(f"Cleaned {table_name}")


if __name__ == "__main__":
    main()