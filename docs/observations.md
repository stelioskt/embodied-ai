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

## 7. Vision-Language-Action Models: OpenVLA and π0

After experimenting with a task-specific Diffusion Policy, I studied OpenVLA and π0 to understand how robotic policies can extend beyond individual tasks.

### OpenVLA

OpenVLA combines visual observations and natural-language instructions to predict robot actions. It uses a pretrained vision-language architecture adapted for robotic control.

A key characteristic is **action tokenization**: continuous action dimensions are discretized into 256 bins and represented as tokens that the language model predicts.

This allows action generation to be formulated similarly to language generation, although discretization introduces a trade-off between representation precision and simplicity.

### π0

π0 also combines visual observations and language instructions, but uses a different approach to action generation.

It extends a pretrained vision-language model with an **action expert** that uses flow matching to generate continuous action sequences.

Unlike OpenVLA's discrete action representation, π0 generates continuous actions through an iterative process that transforms noise into a predicted action trajectory.

This is conceptually related to the generative Diffusion Policy used in PushT, although the underlying training objectives and architectures differ.

### Comparison with PushT Diffusion Policy

| Aspect | PushT Diffusion Policy | OpenVLA | π0 |
|---|---|---|---|
| Inputs | Images, agent state | Images, language | Images, language, robot state |
| Action representation | Continuous | Discretized tokens | Continuous |
| Action generation | Diffusion | Autoregressive token prediction | Flow matching |
| Task scope | Task-specific | Multitask robotics | Multitask robotics |
| Pretraining | Task demonstrations | Vision-language and diverse robot data | Vision-language and diverse robot data |

The main distinction is between learning a policy for a specific manipulation task and developing a general-purpose policy capable of interpreting instructions and transferring knowledge across robotic tasks.

### Connections to Previous Experiments

The PushT experiments highlighted the importance of predicting appropriate action sequences and maintaining stable control during execution.

OpenVLA and π0 introduce additional capabilities through large-scale pretraining, multimodal representations, and diverse robotic demonstrations. However, these capabilities do not eliminate the need for accurate low-level control.

An interesting connection is the relationship between **action chunking and feedback frequency**. This was already relevant to my PushT experiments and remains important in more advanced VLA architectures.

### Questions for Further Investigation

- How does discretizing actions affect the precision of robotic manipulation?
- What are the practical differences between diffusion and flow matching?
- How does language conditioning improve generalization to new tasks?
- How can a pretrained VLA model be adapted to a new robot?
- Can the instability observed in PushT be reduced through more frequent feedback or improved action prediction?