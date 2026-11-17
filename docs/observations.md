# Observations So Far

## 1. PushT Simulation and Diffusion Policy

I trained a Diffusion Policy on the PushT demonstration dataset using LeRobot and evaluated it in simulation.

The initial 200-step smoke test confirmed that the training and evaluation pipeline worked, but the policy did not complete any tasks. After training for 20,000 steps, the model demonstrated substantially better behavior.

### Evaluation Results

| Model | Episode length | Success rate | Average maximum reward |
|---|---|---|---|
| Own policy — 200 training steps | 300 | 0/2 (0%) | 0.052 |
| Own policy — 20,000 training steps | 300 | 7/50 (14%) | 0.719 |
| Own policy — 20,000 training steps | 600 | 9/50 (18%) | 0.821 |
| Pretrained Diffusion Policy | 300 | 31/50 (62%) | 0.929 |

The results indicate that the 20,000-step policy learned useful manipulation behavior but remained considerably less reliable than the pretrained model.

## 2. Behavior During Evaluation

While watching the simulation videos, I noticed that the agent sometimes managed to align the T-block with the target but continued moving afterward, disrupting the alignment.

This raises questions about how the policy decides which actions to execute and whether it can maintain a successful configuration.

I also tested whether increasing the episode duration would improve performance. Doubling the maximum length from 300 to 600 steps increased the observed success rate from 14% to 18%.

The improvement was relatively small, suggesting that additional execution time alone is unlikely to resolve the policy's limitations.

## 3. Policy Configuration and Action Chunking

Comparing my trained model with the pretrained checkpoint revealed differences in their configurations:

| Parameter | Own policy | Pretrained policy |
|---|---:|---:|
| Prediction horizon | 64 | 16 |
| Executed actions per chunk | 32 | 8 |
| Observation steps | 2 | 2 |

The pretrained model executes shorter action sequences before generating new predictions.

One possible explanation for the behavior I observed is that longer action chunks reduce the frequency at which the policy can react to changes in the environment. However, this has not been experimentally established.

## 4. Dataset Exploration

I created a Jupyter notebook to explore the PushT demonstrations.

The analysis covers dataset structure, observation images, state and action dimensions, expert trajectories, action distributions, and temporal action windows.

This helps connect the demonstration data to the observations and action sequences used during Diffusion Policy training.

An important distinction is that the agent's position and the commanded action are different quantities, even though both are represented by two-dimensional coordinates.

## 5. Pretrained Model and Reproducibility

I successfully evaluated the published `lerobot/diffusion_pusht` checkpoint after resolving a compatibility issue between its legacy normalization format and my installed LeRobot version.

The checkpoint achieved a 62% success rate over 50 evaluation episodes, compared with 14% for my own model under the same maximum episode length.

The migration process also highlighted the importance of model configuration, normalization statistics, and compatibility between checkpoint formats.

## 6. Questions for Further Investigation

- Why does the policy sometimes disrupt an apparently correct T-block alignment?
- How much does the action execution horizon affect performance?
- Would training for more iterations substantially improve success?
- How does the pretrained model's training procedure differ from mine?
- Can a simpler behavior-cloning policy learn the same manipulation task?
- How do these task-specific policies compare with vision-language-action models?

These observations provide a starting point for further experiments and analysis. They are not intended as a final assessment of the project or an end-of-week reflection.