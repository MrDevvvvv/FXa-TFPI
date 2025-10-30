start=$(pwd)

rm -r ./energy
cp ~/data1/scripts/project_AlphaFold/energy_calc_input/ ./energy/ -r


for t in replicate_*; do

        cd $t

        rm rec* lig* com*

#		cpptraj -i ~/data1/scripts/project_TFPI/get_K1.in
	
        ante-MMPBSA.py  -p stripped_FXa_k1.inp.prmtop -c com.prmtop -r rec.prmtop -l lig.prmtop -n :234-285 -s :Na+,Cl- --radii mbondi2

	sbatch ~/data1/scripts/project_TFPI/run_mmpbsa_FXa_k1.sh
#	sbatch ~/data1/scripts/project_TFPI/run_per_residue_4_4_capped_FXa_k1.sh	

        cd $start

done

