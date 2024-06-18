#! /bin/bash
#$ -S /bin/bash
#$ -pe def_slot 10
#$ -l d_rt=500:20:00 -l s_rt=500:20:00
#$ -l s_vmem=350G,mem_req=35G
#$ -cwd
ulimit -v unlimited
conda activate spades
for F in QC_Data/*_1.fastq.gz; do 
    R=${F%_*}_2.fastq.gz
    BASE=${F##*/}
    SAMPLE=${BASE%_*}
    SAMPLE=${SAMPLE%_*}
    spades.py --meta -1 $F -2 $R -o Output/$SAMPLE -t 10 -m 350
done