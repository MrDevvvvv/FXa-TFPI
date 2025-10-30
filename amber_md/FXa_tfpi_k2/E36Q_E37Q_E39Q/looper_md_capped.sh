start=$(pwd)

cp  ~/data1/scripts/project_AlphaFold/base.cmd/ ./base -r

for i in {1..10}
do
        mkdir replicate_$i
done


for t in replicate_*; do
        cd $t
        echo $t
        ls
	
	cp $start/inp* .
	sbatch ~/data1/scripts/project_AlphaFold/run_cmd.sh	

        cd $start
done

