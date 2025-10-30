#!/bin/bash

mutant=(1-ALA  2-ALA  17-ALA  18-ALA  20-ALA  24-ALA  25-ALA  26-ALA  27-ALA  28-ALA  40-ALA  41-ALA  42-ALA  43-ALA  44-ALA  45-ALA  46-ALA  83-ALA  84-ALA  88-ALA  90-ALA  91-ALA  92-ALA  93-ALA  94-ALA  97-ALA  136-ALA  139-ALA  140-ALA  141-ALA  144-ALA  145-ALA  146-ALA  148-ALA  155-ALA  157-ALA  169-ALA  170-ALA  171-ALA  172-ALA  180-ALA  181-ALA  187-ALA  188-ALA  189-ALA  190-ALA  191-ALA  192-ALA  193-ALA  194-ALA  195-ALA  196-ALA  212-ALA  213-ALA  214-ALA  215-ALA  216-ALA  217-ALA  218-ALA  219-ALA  220-ALA  223-ALA  224-ALA  225-ALA  226-ALA  227-ALA)

start=$(pwd)

for i in "${mutant[@]}"; do
        echo "$i"
        mkdir "$i"
        cd "$i"
        cp ../../leap_14.in .

        sed "s/"F174F_amber.pdb"/"$i".pdb/g" -i leap_14.in
        sed "s/"F174F_postLEap.pdb"/"$i"_postLEap.pdb/g" -i leap_14.in

        pdb4amber -i ../../F174F_amber.pdb -m "$i" -o temp.pdb
        pdb4amber -i temp.pdb -o "$i.pdb" -y
        rm temp.pdb

        tleap -f leap_14.in

	p0=$(grep "TER" -A 1 *postLEap.pdb | head -2 | tail -1 | awk '{print $5}')
        pt=$(grep "TER" -B 1 *postLEap.pdb | head -5 | tail -2 | head -1 | awk '{print $5}')
        echo ":$p0-$pt"

        ante-MMPBSA.py  -p inp.prmtop -c mcom.prmtop -r mrec.prmtop -l mlig.prmtop -s :WAT:Cl-:Na+ -n :$p0-$pt --radii mbondi2

        #sbatch ../run_pbsa_alascan.sh


        cd $start
done

