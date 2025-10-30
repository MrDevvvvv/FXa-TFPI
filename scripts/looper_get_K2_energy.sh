start=$(pwd)

for t in replicate_*; do
        cd $t
        echo $t

        cpptraj -i ~/data1/scripts/project_TFPI/get_K2.in

        cd $start
done

