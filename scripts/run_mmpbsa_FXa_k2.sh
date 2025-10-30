#!/bin/sh
#SBATCH --job-name=MMPBSA
#SBATCH --output=%x_%j.out
#SBATCH --mem=30g
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --partition="cpu-short"
#SBATCH --distribution=cyclic
#SBATCH --time=50:00
#SBATCH --constraint=ib

# User specific aliases and functionsmodule load GCC/12.2.0
module load slurm
module load Boost/1.81.0-GCC-12.2.0
module load CUDA/12.3.2
module load GCC/12.2.0
module load CMake/3.24.3-GCCcore-12.2.0
module load Eigen/3.4.0-GCCcore-12.2.0
module load OpenMPI/4.1.4-GCC-12.2.0
module load Miniconda3


source /home/dveizaj/data1/software/amber24/amber.sh

export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1

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
                        cp  $scripthome_/ -r  $location/../energy
                fi
        done

else
        cp -R $scripthome_ $location/../energy

fi

# Copy topology, coordinate and MD input files to scratch folder. Go to that folder.
cp $location/*.prmtop             $magic
cp $location/../energy/*.in       $magic
cd $magic

cat mmpbsa.in

#Now run mmpbsa calculation
srun -n $SLURM_NTASKS MMPBSA.py.MPI -O -i mmpbsa.in -o MMPBSA_FXa_k2.dat -eo FRAME_RESULTS_MMPBSA_FXa_k2.dat -sp stripped_FXa_k2.inp.prmtop -cp com.prmtop -rp rec.prmtop -lp lig.prmtop -y $location/stripped_FXa_k2_md.nc


# Clean up
mkdir mmpbsa_calculation_k2
mv MMPBSA_FXa_k2.dat mmpbsa_calculation
mv FRAME_RESULTS_MMPBSA_FXa_k2.dat mmpbsa_calculation

# Copy data back to own folder
mv $magic/mmpbsa_calculation_k2/* $location/
rm -r $magic
