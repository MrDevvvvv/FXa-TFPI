start=$(pwd)

for t in replicate*; do
        cd $t
        cd mmgbsa_calculation
        echo $t
	#python ~/data1/scripts/project_AlphaFold/analyse_per_res.py        
	python ~/data1/scripts/project_AlphaFold/analyse_per_res_capped.py	

	#python ~/data1/scripts/project_AlphaFold/analyse_per_res_vmx.py
	#python ~/data1/scripts/project_AlphaFold/analyse_per_res_vmx_capped.py
        cd $start
done

