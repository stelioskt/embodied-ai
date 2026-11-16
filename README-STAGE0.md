# Stage 0 — S6 and S7

## S6: Pretrained PushT evaluation

Run on the GPU server from the repository root:

```bash
bash scripts/server/eval_pretrained_pusht.sh 10 2
```

This evaluates the pretrained `lerobot/diffusion_pusht` policy in synchronous PushT environments and saves outputs under a timestamped `outputs/eval/` directory. It does not train a model. A compatible checkpoint and a working simulator installation are required.

## S7: Dataset exploration

Open `notebooks/01_explore_pusht.ipynb` with the repository `.venv` Python kernel and execute its cells. The notebook inspects metadata, visual observations, feature dimensions and an expert action trajectory.

Install missing notebook packages if needed:

```bash
uv pip install --python .venv/bin/python matplotlib ipykernel
```

## End-of-week notes

Write observations and conclusions in `notes/week-01.md` after finishing the week's activities. `notes/stage-0-study.md` contains questions and task instructions for the study exercises.
