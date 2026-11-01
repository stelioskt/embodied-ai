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

## Open items

- Laptop CPU inference speed is untested (decided by Phase 0).
- Hugging Face free-plan private storage limits are unchecked.
