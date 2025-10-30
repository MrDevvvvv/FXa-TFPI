import itertools
import re

from random import randint

FXa = "IVGGQECKDGECPWQALLINEENEGFCGGTILSEFYILTAAHCLYQAKRFKVRVGDRNTEQEEGGEAVHEVEVVIKHNRFTKETYDFDIAVLRLKTPITFRMNVAPACLPERDWAESTLMTQKTGIVSGFGRTHEKGRQSTRLKMLEVPYVDRNSCKLSSSFIITQNMFCAGYDTKQEDACQGDSGGPHVTRFKDTYFVTGIVSWGEGCARKGKYGIYTKVTAFLKWIDRSMK"

sub1= "DEDSDRAIEGRTATSEYQT"
sub2= "RELLESYIDGRIVEGSDAE"
sub4= "AASTAVVIAGRSLNPNRVT"

AA_num={
    "A":1, "C":2, "D":3,
    "E":4, "F":5, "G":6,
    "H":7, "I":8, "K":9,
    "L":10, "M":11, "N":12,
    "P":13, "Q":14, "R":15,
    "S":16, "T":17, "V":18,
    "W":19, "Y":20,
    }

num_AA= {y: x for x, y in AA_num.items()}


def subpeptides(peptide):
    l = len(peptide)
    ls=[]
    looped = peptide
    for start in range(0, l):
        for length in range(1, l):
            ls.append(looped[start:length])
    return ls

sub3= ""

while not sub3.find('GR') ==9:
    res = []
    for _ in range(19):
        value = randint(1, 20)
        res.append(str(num_AA[value]))
    sub3 = "".join(res)
print(sub2)
print(sub3)

subpeptides1 = list(filter(lambda x: 'GR' in x, subpeptides(sub1)))
subpeptides2 = list(filter(lambda x: 'GR' in x, subpeptides(sub2)))
subpeptides3 = list(filter(lambda x: 'GR' in x, subpeptides(sub3)))
subpeptides4 = list(filter(lambda x: 'GR' in x, subpeptides(sub4)))

peptides = [subpeptides1,subpeptides2,subpeptides3,subpeptides4]

x=1
for peptide in peptides:
    with open("F174F_sub"+str(x)+".csv","a") as f:
        f.write("id,sequence"+"\n")
        for sub in peptide:
            #if len(sub)%2==0:
            left_count = len(sub.split("GR")[0])
            right_count= len(sub.split("GR")[1])
            f.write("F174F_"+str(left_count+1)+"_"+str(str(right_count+1))+","+str(FXa)+":"+str(sub)+"\n")
        f.close()
    x=x+1

