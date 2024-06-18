#!/bin/bash
#$ -S /bin/bash
#$ -pe def_slot 50
#$ -l s_vmem=1750G,mem_req=35G
#$ -cwd
ulimit -v unlimited

# Base directory setup for Kraken2 and Bracken
kraken2_base="/lustre7/home/bhimbiswa/kraken2"
db_path="${kraken2_base}/New_database"
kraken_input_dir="${kraken2_base}/New_analysis/Classify"
bracken_output_dir="${kraken2_base}/New_analysis/Braken"
reads_dir="${kraken2_base}/QC_reads"
filtered_output_dir="${kraken2_base}/New_analysis/Filtered_Bracken"

# Ensure output directories exist
mkdir -p $kraken_input_dir $bracken_output_dir $filtered_output_dir

# External documentation for the database used
# Manuscript: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10132073
# Database download link: https://www.dropbox.com/scl/fo/stf8jsp0t138vu54nc9l3/AIWdnOUuDZ2w9zzKA6BKRAo?rlkey=t6lfd15g7gsnzs1gka5pqnw2e&e=1&dl=0

# Activate Python environment with necessary dependencies
source activate python2

# Processing loop for each sample
for F in ${reads_dir}/*_1.fastq.gz; do
    R="${F%_*}_2.fastq.gz"
    BASE="${F##*/}"
    SAMPLE="${BASE%_*}"
    SAMPLE="${SAMPLE%_*}"
    
    # Define Kraken2 and Bracken output files
    kraken_report_file="${kraken_input_dir}/${SAMPLE}_15.kreport"
    bracken_output_file="${bracken_output_dir}/${SAMPLE}_100.bracken"
    filtered_output_file="${filtered_output_dir}/${SAMPLE}filtered.bracken"

    echo "Running Kraken2 for sample ${SAMPLE}"
    ${kraken2_base}/kraken2 --paired --db $db_path --threads 50 --report $kraken_report_file --confidence 0.15 $F $R
    
    echo "Completed Kraken2 for sample ${SAMPLE}"

    echo "Running Bracken for sample ${SAMPLE}"
    ${kraken2_base}/Bracken/bracken -d $db_path -i $kraken_report_file -o $bracken_output_file -r 150 -l S -t 100
    echo "Completed Bracken for sample ${SAMPLE}"


    conda activate activate python2

    # Filtering Bracken output
    echo "Filtering Bracken output for sample ${SAMPLE}"
    python ${kraken2_base}/Abundance/KrakenTools/filter_bracken.out.py -i $bracken_output_file -o $filtered_output_file --exclude 10239 45202 10090 10089 77133 1329522
    echo "Completed filtering for sample ${SAMPLE}"
done

echo "All processing jobs have been completed."
