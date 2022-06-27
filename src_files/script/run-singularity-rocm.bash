#!/bin/bash

args=''
for i in "$@"; do 
  i="${i//\\/\\\\}"
  args="$args \"${i//\"/\\\"}\""
done
echo $args
ls
if [ "$args" == "" ]; then args="/bin/bash"; fi

tmp=/tmp/$USER/$$
if [[ "$SLURM_TMPDIR" != "" ]]; then
    tmp="$SLURM_TMPDIR/miopen/$$"
fi
mkdir -p $tmp

singularity \
    exec --rocm \
    --bind $tmp:$HOME/.config/miopen \
  --overlay /scratch/bf996/singularity_containers/i21k_env_rocm.ext3:ro \
  --overlay /vast/work/public/ml-datasets/imagenet/imagenet21k_resized.sqf:ro \
  /scratch/work/public/singularity/hudson/images/rocm4.5.2-ubuntu20.04.3.sif \
  /bin/bash -c "
 source /ext3/env.sh
 $args 
"