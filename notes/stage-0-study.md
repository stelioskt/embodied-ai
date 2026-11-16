# Stage 0 study and completion checklist

**Status:** Prompts prepared; answers and personal verification pending.

## S1 — Hugging Face Robotics Course Units 0–1
- What problems are addressed by learned robot policies?
- What does LeRobot provide: datasets, policies, and hardware integration?
- What defines one dataset episode?

## S2 — CS285 behavior cloning
- Write behavior cloning as supervised learning.
- Explain covariate shift and compounded errors during rollout.
- Explain DAgger, its benefits and practical limitations.
- Why can averaging multimodal expert actions be harmful?

## S3 — Accounts
Verify which of GitHub, Hugging Face, Google Colab, W&B, and optional cloud GPU accounts exist. Avoid marking unverified accounts complete.

## S4 — LeRobot installation
Record platform, Python version, pinned LeRobot revision, and import tests. Server training is confirmed; do not assume laptop setup was tested.

## S5 — Repository
Repository exists at `stelioskt/embodied-ai`. This change adds the notes directory.

## S6 — Pretrained PushT Diffusion Policy
Run `bash scripts/server/eval_pretrained_pusht.sh 10 2`. Log model identifier, environment, episode count, success rate, rewards, and video location. This is **inference**, not training.

## S7 — Dataset inspection
Run `notebooks/01_explore_pusht.ipynb`. Record observation keys/shapes, RGB image size, action dimensions, FPS, and behavior seen in the action plot.

## S8 — OpenVLA and π0
- Which foundation model does OpenVLA build on?
- How does it represent actions?
- What is π0's action expert?
- Why are action chunks and continuous actions useful in robotics?

## S9 — Reflection / self-quiz
Answer five Stage 0 questions without references. Document missed concepts and revisions. Mark complete only after actual attempt.
