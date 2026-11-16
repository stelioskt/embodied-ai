#!/usr/bin/env bash
# S6: evaluate the published PushT Diffusion Policy checkpoint (no training).
# Usage: bash scripts/server/eval_pretrained_pusht.sh [episodes] [batch_size]
set -euo pipefail
cd "$(dirname "$0")/../.."

EPISODES="${1:-10}"
BATCH_SIZE="${2:-2}"
if ! [[ "$EPISODES" =~ ^[1-9][0-9]*$ && "$BATCH_SIZE" =~ ^[1-9][0-9]*$ ]]; then
  echo "Usage: $0 [positive_episode_count] [positive_batch_size]" >&2
  exit 2
fi

export SDL_VIDEODRIVER=dummy
export MUJOCO_GL=egl

OUT="outputs/eval/pretrained_diffusion_pusht_$(date +%Y%m%d_%H%M%S)"
".venv/bin/lerobot-eval" \
  --policy.path=lerobot/diffusion_pusht \
  --policy.device=cuda \
  --env.type=pusht \
  --eval.n_episodes="$EPISODES" \
  --eval.batch_size="$BATCH_SIZE" \
  --eval.use_async_envs=false \
  --output_dir="$OUT"

echo "Evaluation output: $OUT"
