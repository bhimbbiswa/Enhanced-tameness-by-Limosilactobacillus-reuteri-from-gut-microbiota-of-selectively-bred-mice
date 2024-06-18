#! /bin/bash
#$ -S /bin/bash
#$ -pe def_slot 20
#$ -l d_rt=500:20:00 -l s_rt=500:20:00
#$ -l s_vmem=700G,mem_req=35G
#$ -cwd
ulimit -v unlimited
conda activate coverm
coverm genome --output-file All_MAGs_abundance -d /MAGs/dereplicated_genomes_new_updated/All_MAGs -x fasta -m relative_abundance \
--min-read-aligned-percent 0.75 --min-read-percent-identity 0.95 --min-covered-fraction 0 -t 20 -p minimap2-sr --bam-file-cache-directory bam \
-c $(for i in {01..80}; do echo -n "/bhimbiswa/MAGs/KneadData/QC_Data/S${i}_1.fastq /bhimbiswa/MAGs/KneadData/QC_Data/S${i}_2.fastq "; done)
