import os
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
RAW_DIR = PROJECT_ROOT / "data" / "raw"

os.environ["KAGGLEHUB_CACHE"] = str(RAW_DIR)

import kagglehub
path = kagglehub.dataset_download("jtrotman/formula-1-race-data")
print("Path to dataset files:", path)