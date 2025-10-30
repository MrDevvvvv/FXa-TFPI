start=$(pwd)

for t in replicate_*; do

        cd $t
	
	sbatch ~/data1/scripts/project_AlphaFold/run_closest_100.sh

        cd $start

done

