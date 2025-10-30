#!/bin/sh
#SBATCH --job-name=MMGBSA-per-residue
#SBATCH --output=%x_%j.out
#SBATCH --mem=3g 
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24
#SBATCH --partition="amd-short"
#SBATCH --distribution=cyclic
#SBATCH --time=1:00:00

#Modules and setups 

module load ALICE
module load GCC/10.2.0
module load slurm
module load CUDA/11.3.1
module load Miniconda3
module load CMake/3.18.4
module load Boost/1.74.0-GCC-10.2.0
module load openmpi/gcc/64
module load python36
#module load mpi4py

source /home/dveizaj/data1/software/amber22/amber.sh

# This slurmm script runs a job for molecular dynamics using Amber.
#
#   Caveats:
# 1. This script was designed to work with my own infrastructure for the standardization of inputs.
# 2. Parameters such as job name, partition, time etc. may need adjusting for your use case.
# 3. The modules above are for my current installation of Amber20. You may want to use the module.
# 4. While I do try to document this well there is no real support offered for this script.

# Store the location of the job for later reference.
location=$(pwd)

# Make up a collision-free name for putting sratch data.
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

# Determine input file folder for MD input
scripthome_="/home/dveizaj/data1/scripts/project_AlphaFold/energy_calc_input/"

# This section has the gloriously generic task of checking if the input files are there.
#  a.  if there no 'energy' folder, then it will copy it from a central location
#  b.  if there is a 'energy' folder then any missing files will be added.

if [ -d "$location/../energy" ]
then
        for input in $( ls $scripthome_ )
        do
                if [ ! -f "$location/../energy/$input" ]
                then
                        cp  $scripthome_/  $location/../energy -r
                fi
        done

else
        cp -R $scripthome_ $location/../energy

fi

# Copy topology, coordinate and MD input files to scratch folder. Go to that folder.
cp $location/*.prmtop             $magic
cp $location/../energy/*.in       $magic
cd $magic

#Now run mmgbsa calculation
mpirun -np 24 --oversubscribe MMPBSA.py.MPI -O -i mmgbsa_per_residue_4_4.in -o MMGBSA_per_res.dat -do FRAME_RESULTS_MMGBSA_per_res.dat -sp inp.prmtop -cp com.prmtop -rp rec.prmtop -lp lig.prmtop -y $location/md.nc


# Clean up
mkdir mmgbsa_calculation
mkdir mmgbsa_out
mv MMGBSA_per_res.dat mmgbsa_calculation
mv FRAME_RESULTS_MMGBSA_per_res.dat mmgbsa_calculation

mv *_MM* mmgbsa_out

# Copy data back to own folder
cp -r $magic/* $location

