#!/bin/bash

#SBATCH --job-name=reficr_training
#SBATCH --output=reficr_training.out
#SBATCH --error=reficr_training.err
#SBATCH --mem=48G
#SBATCH --cpus-per-task=30
#SBATCH --gres=gpu:2
#SBATCH --time=12:00:00

# Run script in container
# singularity exec --nv /ceph/project/python/python_3.10.sif bash run.sh
singularity exec --nv p9-reficr_latest.sif bash run_multi-gpu.sh
