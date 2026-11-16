# Week 01 — Foundation and first PushT experiment

**Status:** Initial observations. S6/S7 execution and remaining study tasks pending.

## Objective
Stage 0 of the Embodied AI & VLA Project Plan covers LeRobot setup, robotics/imitation-learning reading, pretrained PushT evaluation, dataset exploration, and reflection.

## Observed results (16 November 2026)
- Server: NVIDIA RTX 4080 (~16 GB VRAM), LeRobot 0.6.2, PyTorch 2.11.0+cu128, CUDA available.
- Diffusion Policy smoke run: 200 optimizer steps, effective batch size 8, dataset `lerobot/pusht` (206 episodes, 25,650 frames). Model: 262,709,026 trainable parameters.
- Reported step-200 training metrics: loss 0.389, gradient norm 7.582, learning rate 2.0e-05, 54 samples/s, GPU memory 4.97 GB.
- Checkpoint: `outputs/train/diffusion_pusht_smoke/checkpoints/000200/pretrained_model`.
- Synchronous evaluation (`--eval.use_async_envs=false`) completed two simulation episodes: 0/2 successes, cumulative rewards 12.8018 and 0, maximum step rewards 0.1040 and 0. Evaluation videos saved under `outputs/train/diffusion_pusht_smoke/eval/videos_step_000200/pusht_0/`.
- The 200-step run is **a pipeline test**, not proof of a competent policy. Only ~0.06 dataset-epoch equivalents were processed; two rollouts cannot estimate success reliably.
- With asynchronous evaluation, spawned Gymnasium workers raised `NamespaceNotFound: gym_pusht` even though a direct `import gym_pusht; gym.spec('gym_pusht/PushT-v0')` succeeded. Synchronous evaluation bypassed the problem; root cause remains unresolved.
- TorchCodec could not load FFmpeg shared libraries, but LeRobot used PyAV and training/evaluation proceeded. A Pygame `pkg_resources` deprecation warning was nonfatal.
- A **full** training run was started afterward; its results have **not yet been supplied**. Do not infer improvement or mark it complete.

## Next steps
1. S6: evaluate an **already pretrained** Diffusion Policy; inspect videos and record metrics separately from the scratch-trained model.
2. S7: run `notebooks/01_explore_pusht.ipynb`; inspect image/state/action features and plot one expert trajectory.
3. Collect full-mode loss, success rates, and checkpoints; later compare models with consistent 50-episode evaluations.
4. Complete S1/S2/S8 study notes and S9 self-quiz using `notes/stage-0-study.md`.

## Key learning
Diffusion loss measures noise-prediction performance, not task success. Success must be measured in rollouts with enough independent episodes.
