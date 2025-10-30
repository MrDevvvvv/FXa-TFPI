import pandas as pd


mmgbsa_per_res = pd.read_table("FRAME_RESULTS_MMGBSA_per_res.dat", sep=',', skiprows = 8, skipfooter=160, header=None)
residue = mmgbsa_per_res.iloc[:,0]
vdw = mmgbsa_per_res.iloc[:,5]
electrostatic = mmgbsa_per_res.iloc[:,8]
polar = mmgbsa_per_res.iloc[:,11]
nonpolar = mmgbsa_per_res.iloc[:,14]
energy_total = mmgbsa_per_res.iloc[:,17]
df = pd.DataFrame({'Residue': residue, 'VDW': vdw, 'Electrostatic': electrostatic, 'Polar solvation': polar,
                   'Non-polar solvation': nonpolar, 'Total energy': energy_total})
df.to_csv('mmgbsa_per_res.csv', index=False)

