#!/bin/bash

#SBATCH --job-name=Closest
#SBATCH --output=%x_%j.out
#SBATCH --mem=3g
#SBATCH --nodes=1
#SBATCH --cpus-per-gpu=1
#SBATCH --gpus-per-task=1
#SBATCH --partition="amd-short"
#SBATCH --gpus=1
#SBATCH --gres=gpu:1
#SBATCH --distribution=cyclic
#SBATCH --time=40:00

#Modules and setups

module load ALICE
module load GCC/10.2.0
module load slurm
module load CUDA/11.3.1
module load Miniconda3
module load CMake/3.18.4
module load Boost/1.74.0-GCC-10.2.0
module load openmpi/gcc/64
#module load mpi4py

source /home/dveizaj/data1/software/amber22/amber.sh

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
scripthome="/home/dveizaj/data1/scripts/project_AlphaFold"

# Check if a cuda run is already going and set visible devices as needed.
export CUDA_VISIBLE_DEVICES="$(nvidia-smi | grep -A 1000 "Processes"  | grep "MiB" | wc -l)"


#Copy everything to our working directory in scratch, and move ourselves there too.
cp $scripthome/closest_60.in   $magic/
cp $location/inp.prmtop 	$magic/
cd                              $magic

p0=$(grep "TER" -A 1 $location/../*postLEap.pdb | head -2 | tail -1 | awk '{print $5}')
pt=$(grep "TER" -B 1 $location/../*postLEap.pdb | head -5 | tail -2 | head -1 | awk '{print $5}')
echo ":$p0-$pt"
	
sed -i "s/:XXX/:$p0-$pt/g" closest_60.in	

cat closest_60.in

mpirun -np 24 --oversubscribe cpptraj.MPI -p inp.prmtop -y $location/md.nc -i closest_60.in

 
ante-MMPBSA.py -p closest.inp.prmtop -c closest_com.prmtop -r closest_rec.prmtop -l closest_lig.prmtop -n :$p0-$pt -s :Na+ --radii mbondi2

## Cleanup comment out these lines for debugging.
cd $location
cp $magic/*closest* $magic/closest_60.in $location && rm -R $magic


