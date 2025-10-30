p0=$(grep "TER" -A 1 *amber.pdb | head -2 | tail -1)
pt=$(grep "TER" -B 1 *amber.pdb | head -5 | tail -2)

sed "s/ N / C /g" "$p0"
#sed "s/ ALA / ACE /g" $p0
