#!/bin/bash
#$ -S /bin/bash
#$ -pe def_slot 1
#$ -l s_vmem=20G,mem_req=20G
#$ -cwd
ulimit -v unlimited

conda activate biobakery3

# Directories for input and output
input_dir="/bhimbiswa/KneadData/QC_Data"
output_dir="/bhimbiswa/Humann3/New_output"

# Process each sample
for F in ${input_dir}/*_1.fastq.gz; do
    sample_name=$(basename ${F})
    sample_name=${sample_name%_1.fastq.gz}
    sample_output="${output_dir}/${sample_name}"

    echo "Running HUMAnN for sample ${sample_name}"
    humann --input ${F} \
           --output ${sample_output} \
           --threads 1 \
           --bypass-prescreen
    echo "HUMAnN processing for ${sample_name} completed."

    # Normalize the gene families table
    humann_renorm_table --input ${sample_output}/genefamilies.tsv \
                        --output ${sample_output}/genefamilies_relab.tsv \
                        --units relab
done

echo "All samples have been processed."

# Join tables for gene families, path coverage, and path abundance
humann_join_tables --input $output_dir --output ${output_dir}/humann_genefamilies.tsv --file_name genefamilies_relab
humann_join_tables --input $output_dir --output ${output_dir}/humann_pathcoverage.tsv --file_name pathcoverage
humann_join_tables --input $output_dir --output ${output_dir}/humann_pathabundance.tsv --file_name pathabundance_relab

echo "Tables joined and processing completed."
