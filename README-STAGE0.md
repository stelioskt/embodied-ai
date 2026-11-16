# Stage 0 additions: S6 and S7

This repo includes an S6 pretrained PushT evaluation script, an S7 dataset exploration notebook, and initial study notes.

## S6: evaluate a published pretrained policy

On the GPU server, from the repository root:

```bash
bash scripts/server/eval_pretrained_pusht.sh 10 2
```

This evaluates `lerobot/diffusion_pusht` with synchronous simulation (our asynchronous workers previously failed to register `gym_pusht`). It saves evaluation artifacts under a timestamped `outputs/eval/` directory. It **does not train a model**. The model is downloaded from Hugging Face if not already cached.

Confirm that the upstream checkpoint is compatible with the installed/pinned LeRobot revision before interpreting scores. Record success count, average rewards and video observations in `notes/week-01.md`. Use 50+ evaluation episodes and controlled settings for later comparisons.

## S7: inspect expert demonstrations

Launch `notebooks/01_explore_pusht.ipynb` with the repository `.venv` Python kernel. Execute all cells and save the executed notebook. It displays dataset metadata, a sample image, feature shapes, and the first episode's two action traces.

If missing, install notebook dependencies:
```bash
uv pip install --python .venv/bin/python matplotlib ipykernel
```

## Remaining study work
`notes/stage-0-study.md` lists S1–S9 study prompts. Reading and a self-quiz cannot be marked complete by writing placeholders.

## Full-mode training
A full-mode run was started after the smoke test, but the final logs have not been shared. It is separate from S6 pretrained inference; do not record unverified results.
