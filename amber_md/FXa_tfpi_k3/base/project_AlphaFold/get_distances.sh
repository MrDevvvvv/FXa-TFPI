grep "GLY B" -A 10 *unrelaxed_rank_001_* |  grep "C   ARG"| cut -c 7-10,104-127 > F174F_ARG.csv
grep "ASP A 184" -A 10 *unrelaxed_rank_001_* |  grep "OG  SER A 185" | cut -c 7-10,104-127 > F174F_SER185.csv
paste F174F_ARG.csv F174F_SER185.csv | awk '!($5="")' > ARG-C_SER-O.csv

grep "GLY B" -A 10 *unrelaxed_rank_001_* |  grep "NH1 ARG"| cut -c 7-10,104-127 > F174F_ARG_NH1.csv
grep "GLU A 178" -A 10 *unrelaxed_rank_001_* |  grep "OD2 ASP A 179" | cut -c 7-10,104-127 > F174F_ASP_OD2.csv
paste F174F_ARG_NH1.csv F174F_ASP_OD2.csv | awk '!($5="")' > ARG-NH1_ASP-OD2.csv

grep "GLY B" -A 10 *unrelaxed_rank_001_* |  grep "NH2 ARG"| cut -c 7-10,104-127 > F174F_ARG_NH2.csv
grep "GLU A 178" -A 10 *unrelaxed_rank_001_* |  grep "OD1 ASP A 179" | cut -c 7-10,104-127 > F174F_ASP_OD1.csv
paste F174F_ARG_NH2.csv F174F_ASP_OD1.csv | awk '!($5="")' > ARG-NH2_ASP-OD1.csv
