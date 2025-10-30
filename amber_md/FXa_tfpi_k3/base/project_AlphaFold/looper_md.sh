start=$(pwd)

cp  ~/data1/scripts/project_AlphaFold/leap_14.in .
#cp  ~/data1/scripts/project_AlphaFold/prepper.sh .
cp  ~/data1/scripts/project_AlphaFold/base.cmd/ ./base -r

for i in {2..10}
do
        mkdir replicate_$i
done

$start/prepper.sh

for t in replicate_*; do
        cd $t
        echo $t
        ls
	
	cp $start/*amber.pdb .
	tleap -f $start/leap_14.in
	sbatch ~/data1/scripts/project_AlphaFold/run_cmd.sh	

        cd $start
done

