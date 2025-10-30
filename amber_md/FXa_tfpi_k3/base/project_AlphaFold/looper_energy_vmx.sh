start=$(pwd)

for t in replicate_*; do

        cd $t

        rm rec* lig* com*

        p0=$(grep "TER" -A 1 *postLEap.pdb | head -2 | tail -1 | awk '{print $5}')
        pt=$(grep "TER" -B 1 *postLEap.pdb | head -5 | tail -2 | head -1 | awk '{print $5}')
        echo ":$p0-$pt"

        ante-MMPBSA.py  -p inp.prmtop -c com.prmtop -r rec.prmtop -l lig.prmtop -s :WAT,Cl-,Na+ -n :$p0-$pt --radii mbondi2

	#sbatch ~/data1/scripts/project_AlphaFold/run_mmpbsa.sh
	#sbatch ~/data1/scripts/project_AlphaFold/run_mmgbsa.sh
	#sbatch ~/data1/scripts/project_AlphaFold/run_per_residue_4_4.sh	
	sbatch ~/data1/scripts/project_AlphaFold/run_per_residue_4_4_capped_vmx.sh	

        cd $start

done

