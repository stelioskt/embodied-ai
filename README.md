# embodied-ai

Embodied AI / VLA project built on [LeRobot](https://github.com/huggingface/lerobot).

## Architecture

| Machine | Role |
|---|---|
| Laptop (Windows) | Robot side: calibration, teleoperation, data recording, running policies on the robot |
| Server (RTX 4080, Linux) | Compute side: training, headless simulation, evaluation |
| Hugging Face Hub | Transfer point for datasets and checkpoints |
| GitHub | Code and configs (this repo), cloned on both machines |
| Weights & Biases | Training logs |

See [docs/architecture.md](docs/architecture.md) for the data flow and phases.

## Layout

```
configs/            train / eval configs
scripts/laptop/     setup + robot-side scripts
scripts/server/     setup + training / sim scripts
docs/               architecture and setup notes
notebooks/          exploration
third_party/lerobot LeRobot, pinned as a git submodule
data/, outputs/     git-ignored; real artifacts live on the Hub
```

## Setup

Clone with submodules:

```bash
git clone --recurse-submodules <repo-url>
```

Laptop (PowerShell):

```powershell
.\scripts\laptop\setup.ps1
```

Server (bash):

```bash
bash scripts/server/setup.sh
```

Both create `.venv` with Python 3.12 and install LeRobot editable from `third_party/lerobot`.
