#!/usr/bin/env bash
set -euo pipefail

# S6: evaluate the legacy pretrained PushT Diffusion Policy with LeRobot 0.6.x.
# Usage: bash scripts/server/eval_pretrained_pusht.sh [episodes] [episode_steps]
cd "$(dirname "$0")/../.."

EPISODES="${1:-50}"
EPISODE_STEPS="${2:-300}"
BATCH_SIZE=10
SOURCE="lerobot/diffusion_pusht"
MIGRATED="outputs/models/diffusion_pusht_migrated"

for value in "$EPISODES" "$EPISODE_STEPS"; do
  if ! [[ "$value" =~ ^[1-9][0-9]*$ ]]; then
    echo "Episode count and episode length must be positive integers." >&2
    exit 2
  fi
done

export SDL_VIDEODRIVER=dummy
export MUJOCO_GL=egl

# Older published checkpoints store normalization buffers in model weights.
# LeRobot 0.6.x expects separate pre-/post-processing pipelines.
if [[ ! -f "$MIGRATED/model.safetensors" ||
      ! -f "$MIGRATED/config.json" ||
      ! -f "$MIGRATED/policy_preprocessor.json" ||
      ! -f "$MIGRATED/policy_postprocessor.json" ]]; then
  echo "Migrating pretrained checkpoint locally (original Hugging Face repo is unchanged)..."
  .venv/bin/python -m lerobot.processor.migrate_policy_normalization \
    --pretrained-path "$SOURCE" \
    --output-dir "$MIGRATED"
fi

OUT="outputs/eval/pretrained_pusht_${EPISODE_STEPS}steps_${EPISODES}ep_$(date +%Y%m%d_%H%M%S)"
echo "Evaluating migrated checkpoint: $MIGRATED"

.venv/bin/lerobot-eval \
  --policy.path="$MIGRATED" \
  --policy.device=cuda \
  --env.type=pusht \
  --env.episode_length="$EPISODE_STEPS" \
  --eval.n_episodes="$EPISODES" \
  --eval.batch_size="$BATCH_SIZE" \
  --eval.use_async_envs=false \
  --seed=1000 \
  --output_dir="$OUT"

echo "Results: $OUT"
