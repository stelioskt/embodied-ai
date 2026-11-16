
#!/usr/bin/env bash
set -euo pipefail

# Always run from the repository root.
cd "$(dirname "$0")/../.."

# Headless simulation on the GPU server.
export SDL_VIDEODRIVER=dummy
export MUJOCO_GL=egl

# Evaluate the pretrained Diffusion Policy.
.venv/bin/lerobot-eval \
  --policy.path=lerobot/diffusion_pusht \
  --policy.device=cuda \
  --env.type=pusht \
  --env.episode_length=300 \
  --eval.n_episodes=50 \
  --eval.batch_size=10 \
  --eval.use_async_envs=false \
  --seed=1000 \
  --output_dir=outputs/eval/pretrained_pusht_300steps_50ep
