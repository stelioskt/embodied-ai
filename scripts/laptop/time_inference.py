"""Time policy inference on the laptop CPU.

Builds an untrained policy with the PushT feature shapes and measures select_action latency.
Latency does not depend on the weights, so this answers whether the laptop can drive a robot
at the control rate (SO-101 data is usually recorded at 30 fps).

Usage: .venv\\Scripts\\python.exe scripts/laptop/time_inference.py [act|diffusion] [n_runs]
"""

import sys
import time

import torch

from lerobot.datasets import LeRobotDatasetMetadata
from lerobot.policies.factory import make_policy, make_policy_config

policy_type = sys.argv[1] if len(sys.argv) > 1 else "act"
n_runs = int(sys.argv[2]) if len(sys.argv) > 2 else 50

meta = LeRobotDatasetMetadata("lerobot/pusht")
cfg = make_policy_config(policy_type, device="cpu")
policy = make_policy(cfg, ds_meta=meta).eval()
n_params = sum(p.numel() for p in policy.parameters())
print(f"{policy_type}: {n_params / 1e6:.1f}M parameters, threads={torch.get_num_threads()}")


def random_obs():
    obs = {}
    for key, feat in cfg.input_features.items():
        obs[key] = torch.rand(1, *feat.shape)
    return obs


policy.reset()
with torch.inference_mode():
    policy.select_action(random_obs())  # warm-up
    times = []
    for _ in range(n_runs):
        policy.reset()  # force a fresh forward pass every call (worst case, no action chunk reuse)
        obs = random_obs()
        t0 = time.perf_counter()
        policy.select_action(obs)
        times.append(time.perf_counter() - t0)

times.sort()
median = times[len(times) // 2]
print(f"median {median * 1000:.0f} ms | p95 {times[int(len(times) * 0.95)] * 1000:.0f} ms | max {times[-1] * 1000:.0f} ms")
print(f"=> worst case {1 / median:.1f} policy calls/s (ACT predicts a chunk, so real control rate is higher)")
