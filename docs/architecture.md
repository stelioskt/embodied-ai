# Architecture

```
 Laptop (Windows)                 Hugging Face Hub                     Server (RTX 4080)
 - robot, cameras                 - datasets   <-- push ---------      - training
 - record / teleop      -- push > - checkpoints <-- push ---------      - sim evaluation
 - run policy on robot  <- pull -                   -- pull ------>

 GitHub: code and configs, cloned on both machines
 W&B:    training curves
 SSH:    the laptop starts and watches jobs on the server
```

## Principles

- The server is disposable: everything on it is rebuilt from Git and the Hub.
- Checkpoints are pushed to the Hub during training so a crash loses nothing.
- Both machines run the same LeRobot commit (the submodule pin) and Python 3.12.
- The same pipeline is used in simulation and on the real robot.

## Phases

0. Pipeline in simulation: train ACT on a public sim dataset on the server, evaluate headless,
   time policy inference on the laptop CPU.
1. Real robot: calibrate, teleoperate, record ~50 episodes of one task, push to the Hub.
2. Train ACT on the server from that dataset, run it on the robot.
3. SmolVLA fine-tuning on the server (small batch / LoRA to fit 16 GB). Rent a GPU only if needed.

## Setup notes

- Laptop: `torchcodec` fails to load on Windows (checked with LeRobot v0.6.1, torch 2.11 CPU).
  LeRobot detects this and uses `pyav` instead, so the laptop installs the `av-dep` extra.
- The server extras in `scripts/server/setup.sh` are untested until it is run on the server.

## Open items

- Laptop CPU inference (`scripts/laptop/time_inference.py act`): ACT, 51.6M params, PushT input
  (one 384x384 camera): median 49 ms, p95 66 ms per forward pass. Promising, but the SO-101 setup
  uses two cameras at higher resolution, so re-measure with the real input shapes.
- Experiment tracking: LeRobot 0.6 uses Trackio (local, free), not W&B; a W&B account is optional.
- Hugging Face free-plan private storage limits are unchecked.
