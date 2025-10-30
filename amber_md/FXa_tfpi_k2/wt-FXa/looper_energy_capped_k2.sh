start=$(pwd)

#rm -r ./energy
#cp ~/data1/scripts/project_AlphaFold/energy_calc_input/ ./energy/ -r


for t in replicate_*; do

        cd $t

#       rm rec* lig* com*

	#cpptraj -i ~/data1/scripts/project_TFPI/get_K2.in
	
 #       ante-MMPBSA.py  -p inp.prmtop -c com.prmtop -r rec.prmtop -l lig.prmtop -n :234-284 -s :Na+,Cl-,WAT --radii mbondi2

	sbatch /home/dveizaj/data1/TFPI/amber_md/FXa_tfpi_k2/wt-FXa/run_mmpbsa_TFPI.sh
#	sbatch ~/data1/scripts/project_TFPI/run_mmpbsa_FXa_k2.sh
#	sbatch ~/data1/scripts/project_TFPI/run_per_residue_4_4_capped_FXa_k2.sh	

        cd $start

done

