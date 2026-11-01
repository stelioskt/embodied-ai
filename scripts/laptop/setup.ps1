# Laptop setup (Windows): Python 3.12 venv + LeRobot editable install.
$ErrorActionPreference = "Stop"
$root = Resolve-Path "$PSScriptRoot\..\.."
Set-Location $root

git submodule update --init --recursive
uv venv --python 3.12 .venv
# Default PyPI torch on Windows is the CPU build, which is what the laptop needs.
uv pip install --python .venv\Scripts\python.exe -e third_party/lerobot
# Add robot extras once hardware is chosen, e.g. -e "third_party/lerobot[feetech]"

.venv\Scripts\python.exe -c "import lerobot, torch; print('lerobot', lerobot.__version__, '| torch', torch.__version__)"
