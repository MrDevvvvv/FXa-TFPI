#!/bin/bash

#SBATCH --job-name=AF2
#SBATCH --output=%x_%j.out
#SBATCH --mem=3g
#SBATCH --nodes=1
#SBATCH --cpus-per-gpu=1
#SBATCH --gpus-per-task=1
#SBATCH --partition="gpu-medium"
#SBATCH --gpus=1
#SBATCH --gres=gpu:1
#SBATCH --distribution=cyclic
#SBATCH --time=1-00:00:00

#Modules and setups

module load GCC/10.2.0
module load slurm
module load CUDA/11.3.1
module load Miniconda3
module load CMake/3.18.4
module load Boost/1.74.0-GCC-10.2.0
module load openmpi/gcc/64
module load mpi4py

export PATH="/home/dveizaj/data1/software/localcolabfold/colabfold-conda/bin:$PATH"


# Store the location of the job for later reference.
location=$(pwd)

# Make up a collision-free name for putting sratch data.
if [ -z $TMPDIR ]
then
        random=$(echo $RANDOM | shasum | cut -c 1-10)
        magic="/scratch/$random"
        mkdir $magic
else
        magic=$TMPDIR
        location=$SLURM_SUBMIT_DIR
fi

# Write some info to the slurm file..
echo "== Starting run at $(date)"
echo "== Job ID     : ${SLURM_JOBID}"
echo "== Node list  : ${SLURM_NODELIST}"
echo "== Local dir. : ${location}"
echo "== Magic dir. : ${magic}"

# Copy input files to scratch folder. Go to that folder.
cp $location/*.csv              $magic/input.csv
cd $magic


# Run AlphaFold
colabfold_batch --use-gpu-relax --num-recycle 12 --model-type alphafold2_multimer_v3 input.csv $location

cp -r $magic/* $location
rm -R $magic
