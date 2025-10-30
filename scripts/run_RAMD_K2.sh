#!/bin/bash

#SBATCH --job-name=RAMD
#SBATCH --output=%x_%j.out
#SBATCH --mem=3g 
#SBATCH --nodes=1
#SBATCH --cpus-per-gpu=1
#SBATCH --gpus-per-task=1
#SBATCH --partition="gpu-long"
#SBATCH --gpus=1
#SBATCH --gres=gpu:1
#SBATCH --distribution=cyclic
#SBATCH --time=1-00:00:00

module purge

#Modules and setups
module load shared
module load ALICE/default
module load slurm
module load Boost/1.81.0-GCC-12.2.0
module load CUDA/12.3.2
module load GCC/12.2.0
module load CMake/3.24.3-GCCcore-12.2.0
module load OpenMPI/4.1.4-GCC-12.2.0


source /home/dveizaj/data1/software/amber24/amber.sh

# Store the location of the job for later reference.
location=$(pwd)

if [ -z $TMPDIR ]
then
        random=$(echo $RANDOM | shasum | cut -c 1-10)
        magic="/scratchdata/$random"
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

#Determine input file folder for MD input
scripthome="/home/dveizaj/data1/scripts"

echo "## Number of available CUDA devices: $CUDA_VISIBLE_DEVICES"
echo "## Checking status of CUDA device with nvidia-smi" 
nvidia-smi

#Copy everything to our working directory in scratch, and move ourselves there too.
cp $location/../base/pme*in     $magic/
cp *rst *out                    $magic/
cp inp.prmtop inp.inpcrd        $magic/
cd                              $magic

#Begin RAMD after checking whether the normal MD has finished.

if [ -f "$location/md.nc" ]; then
    pmemd.cuda  -O -i pme_md_RAMD_K2.in -o RAMD.out -p inp.prmtop -c md.rst -x RAMD.nc
fi

## Cleanup comment out these lines for debugging.
cd $location
cp $magic/RAMD.out $magic/RAMD.rst $magic/RAMD.nc $location && rm -R $magic

