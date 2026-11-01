#!/usr/bin/env bash
# Phase 0: train a policy on the public PushT sim dataset and evaluate it in simulation.
# Usage: bash scripts/server/train_pusht.sh smoke|full
#   smoke: 200 steps, 2 eval episodes - proves the whole pipeline in a few minutes
#   full:  20k steps with periodic eval - a first real learning curve
# Run inside tmux for the full run so it survives a dropped connection.
set -euo pipefail
cd "$(dirname "$0")/../.."
source .venv/bin/activate

# Headless rendering for the sim
export SDL_VIDEODRIVER=dummy
export MUJOCO_GL=egl

MODE="${1:-smoke}"
POLICY="${POLICY:-diffusion}"   # diffusion is the reference PushT policy; try POLICY=act too

case "$MODE" in
  smoke) STEPS=200;   EVAL_FREQ=200;   EVAL_EPISODES=2 ;;
  full)  STEPS=20000; EVAL_FREQ=5000;  EVAL_EPISODES=10 ;;
  *) echo "usage: $0 smoke|full"; exit 1 ;;
esac

lerobot-train \
  --dataset.repo_id=lerobot/pusht \
  --env.type=pusht \
  --policy.type="$POLICY" \
  --policy.device=cuda \
  --policy.push_to_hub=false \
  --output_dir="outputs/train/${POLICY}_pusht_${MODE}" \
  --job_name="${POLICY}_pusht_${MODE}" \
  --steps="$STEPS" \
  --env_eval_freq="$EVAL_FREQ" \
  --eval.n_episodes="$EVAL_EPISODES" \
  --eval.batch_size="$EVAL_EPISODES" \
  --save_freq="$STEPS" \
  --trackio.enable=false
