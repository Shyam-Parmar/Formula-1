"""This runs the full F1 data pipeline: fetch, process, load, verify."""

# =========================
# Libraries
# =========================
import subprocess
import sys
from pathlib import Path


# =========================
# Constants
# =========================
SCRIPTS_DIR = Path(__file__).resolve().parent

PIPELINE = [
    "fetch_data.py",
    "process_data.py",
    "upsert_data.py",
    "check_row_count.py"
]


# =========================
# Main
# =========================
def main() -> None:
    for script_name in PIPELINE:
        script_path = SCRIPTS_DIR / script_name
        print(f"\n{'=' * 50}\nRunning {script_name}\n{'=' * 50}")

        result = subprocess.run([sys.executable, str(script_path)])

        if result.returncode !=0:
            print(f"\n{script_name} failed. Stopping pipeline.")
            sys.exit(1)

    print("\nPipeline complete")

if __name__ == "__main__":
    main()