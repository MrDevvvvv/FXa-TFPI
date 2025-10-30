#!/bin/bash

start=$(pwd)

for i in *-ALA; do
  	cd $i
	
	for d in {1..10};
	do
        	mkdir replicate_$d
		cd replicate_$d
		pwd
		#rm rec.prmtop lig.prmtop com.prmtop
		#cp $start/../replicate_$d/inp.prmtop .
		p0=$(grep "TER" -A 1 ../*postLEap.pdb | head -2 | tail -1 | awk '{print $5}')
        	pt=$(grep "TER" -B 1 ../*postLEap.pdb | head -5 | tail -2 | head -1 | awk '{print $5}')
        	echo ":$p0-$pt"
		
		#ante-MMPBSA.py  -p inp.prmtop -c com.prmtop -r rec.prmtop -l lig.prmtop -s :WAT:Cl-:Na+ -n :$p0-$pt --radii mbondi2	
		sbatch ~/data1/scripts/project_AlphaFold/run_ala-scan.sh
		cd ../
	done
	
        cd $start
done

