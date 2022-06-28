#!/bin/bash -x
#SBATCH --output=logs/out_%A_%j.log
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --time=99:59:00
#SBATCH --mem=64GB
#SBATCH --gres=gpu:mi50:1
#SBATCH --wait-all-nodes=1
#SBATCH --job-name=vit_i21k

module purge;

#debug flags
echo $SLURM_JOB_NAME

# COMMENTS

#env vars
export OMP_NUM_THREADS=8
export HOST_NODE_ADDR=$(shuf -i 10000-65500 -n 1)
export MASTER_PORT=$(shuf -i 10000-65500 -n 1)
export MASTER_ADDR="$(hostname -s).hpc.nyu.edu"

#run command
srun --cpu_bind=v --accel-bind=v \
    /bin/bash /scratch/bf996/ImageNet21K/src_files/script/run-singularity-rocm.bash \
    /bin/bash -c \
    'export PYTHONPATH="$PYTHONPATH:$PWD/src_files"; python \
    train_semantic_softmax.py \
    --batch_size=384 \
    --data_path=/imagenet21k_resized \
    --model_name=vit_lucid \
    --model_path="" \
    --epochs=80'



