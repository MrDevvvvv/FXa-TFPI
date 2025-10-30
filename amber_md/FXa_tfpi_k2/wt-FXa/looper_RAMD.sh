start=$(pwd)

#cp  ~/data1/scripts/project_AlphaFold/leap_14.in .
#cp  ~/data1/scripts/project_AlphaFold/prepper.sh .
#cp  ~/data1/scripts/project_AlphaFold/base.cmd/ ./base -r

#$start/prepper.sh

for t in replicate_*; do
        cd $t
        echo $t
        ls
	#sbatch /home/dveizaj/data1/scripts/project_TFPI/run_RAMD_K2.sh

	#cpptraj ~/data1/scripts/project_TFPI/cpptraj_native_RAMD.in
	cpptraj ~/data1/scripts/project_TFPI/cpptraj_native_MD.in
	python3 /home/dveizaj/data1/FXa/amber_md/apix/wt-FXa/replicate_1/plot_contacts_over_time_ns.py  
        cd $start
done

