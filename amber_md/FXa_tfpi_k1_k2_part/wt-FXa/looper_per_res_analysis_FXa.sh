start=$(pwd)

for t in replicate*; do
        cd $t
        cd mmgbsa_calculation
        echo $t
	#python ~/data1/scripts/project_AlphaFold/analyse_per_res.py        
	sed '0,/CYX 355/{/ILE   1/,/CYX 355/p}' FRAME_RESULTS_MMGBSA_per_res.dat -n > FRAME_RESULTS_MMGBSA_per_res_adj.dat
	python3 ~/data1/scripts/project_AlphaFold/python_scripts/analyse_per_res_capped_v2.py	

	#python ~/data1/scripts/project_AlphaFold/analyse_per_res_vmx.py
	#python ~/data1/scripts/project_AlphaFold/analyse_per_res_vmx_capped.py
        cd $start
done

python3 ~/data1/scripts/project_AlphaFold/python_scripts/average_per_residue.py
