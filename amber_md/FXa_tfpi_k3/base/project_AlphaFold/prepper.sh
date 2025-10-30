pdb4amber *unrelaxed* > F174F_amber.pdb --nohyd

sed -i "s/ HIS / HIE /g" F174F_amber.pdb

sed -i "s/CYS A   7/CYX A   7/g" F174F_amber.pdb
sed -i "s/CYS A  12/CYX A  12/g" F174F_amber.pdb
sed -i "s/CYS A  27/CYX A  27/g" F174F_amber.pdb
sed -i "s/CYS A  43/CYX A  43/g" F174F_amber.pdb

sed -i "/END/d" F174F_amber.pdb

#echo "CONECT   47   83" >> F174F_amber.pdb
#echo "CONECT  206  324" >> F174F_amber.pdb
#echo "END" >> F174F_amber.pdb

tail F174F_amber.pdb


