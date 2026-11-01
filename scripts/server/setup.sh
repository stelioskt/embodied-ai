#!/usr/bin/env bash
# Server setup (Linux, NVIDIA GPU): Python 3.12 venv + LeRobot editable install.
set -euo pipefail
cd "$(dirname "$0")/../.."

git submodule update --init --recursive
export PATH="$HOME/.local/bin:$PATH"
command -v uv >/dev/null || curl -LsSf https://astral.sh/uv/install.sh | sh
uv venv --python 3.12 .venv
# No system ffmpeg on this server, so install pyav (bundles ffmpeg) as the video fallback.
uv pip install --python .venv/bin/python -e "third_party/lerobot[dataset,av-dep,training,pusht,aloha]"
# Later: add smolvla for SmolVLA fine-tuning
# Headless sim rendering: export MUJOCO_GL=egl before running lerobot-eval.

nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader
.venv/bin/python -c "import lerobot, torch; print('lerobot', lerobot.__version__, '| torch', torch.__version__, '| cuda', torch.cuda.is_available())"
