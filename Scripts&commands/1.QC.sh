#! /bin/bash
#$ -S /bin/bash
#$ -pe def_slot 10 
#$ -l s_vmem=160G,mem_req=16G
#$ -cwd
ulimit -v unlimited

for F in RAW_READS/*_1.fastq; do 
	R=${F%_*}_2.fastq
	BASE=${F##*/}
	SAMPLE=${BASE%_*}
	kneaddata --input $F --input $R -o READ_QC/$SAMPLE -db /database/PhiX -db /database/hg37dec_v0.1 -db /database/mouse_C57BL_6NJ -db /database/human_hg38_refMrna --sequencer-source TruSeq2 --run-fastqc-start --run-fastqc-end -t 10 -p 10 --reorder
done