start=$(pwd)

for t in replicate_*; do

        cd $t

        p0=$(grep "TER" -A 1 ../*postLEap.pdb | head -2 | tail -1 | awk '{print $5}')
        pt=$(grep "TER" -B 1 ../*postLEap.pdb | head -5 | tail -2 | head -1 | awk '{print $5}')
        echo ":$p0-$pt"

	sbatch  ~/data1/scripts/project_AlphaFold/run_mmpbsa_closest.sh

        cd $start

done

