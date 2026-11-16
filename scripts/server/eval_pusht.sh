
#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../.."

STEPS="${1:-300}"
EPISODES="${2:-50}"

export SDL_VIDEODRIVER=dummy
export MUJOCO_GL=egl

.venv/bin/lerobot-eval \
  --policy.path=outputs/train/diffusion_pusht_full/checkpoints/020000/pretrained_model \
  --policy.device=cuda \
  --env.type=pusht \
  --env.episode_length="$STEPS" \
  --eval.n_episodes="$EPISODES" \
  --eval.batch_size=10 \
  --eval.use_async_envs=false \
  --seed=1000 \
  --output_dir="outputs/eval/pusht_20k_${STEPS}steps_${EPISODES}ep"
