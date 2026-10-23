#!/bin/bash

set -e

input_dir="/mnt/pikachu/dwools/flt3/nanopore_FLT3_20240621_Flt3_amplicon_B/barcode_bam_files"
input_bam="101060b6-feca-40e4-807d-eb79553bafe8_SQK-NBD114-24_barcode01.bam"
input_bam_bai="${input_bam}.bai"
reference_genome="/mnt/pikachu/dwools/flt3/nanopore_FLT3_20240621_Flt3_amplicon_B/genome/GRCh38_primary_assembly_genome.fa"
reference_genome_index="${reference_genome}.fai"
matched_control="/mnt/pikachu/dwools/flt3/nanopore_FLT3_20240621_Flt3_amplicon_B/matchedControl_gm24385_2023.12/matchedControl_gm24385_flt3/matchedControl_gm24385_flt3.bam"
output_dir="/mnt/pikachu/dwools/flt3/nanopore_FLT3_20240621_Flt3_amplicon_B/variants/flt3-itd_results"
regions_bed="/mnt/pikachu/dwools/flt3/nanopore_FLT3_20240621_Flt3_amplicon_B/genome/GRCh38_FLT3-full.bed"

# CuteSV_output_dir="${output_dir}/CuteSV"
# DeBreak_output_dir="${output_dir}/DeBreak"
# Delly_output_dir="${output_dir}/Delly"
# Dysgu_output_dir="${output_dir}/Dysgu"
# Nanomansv_output_dir="${output_dir}/Nanomansv"
# NanoVar_output_dir="${output_dir}/NanoVar"
# Savana_output_dir="${output_dir}/Savana"
# Severus_output_dir="${output_dir}/Severus"
Sniffles2_output_dir="${output_dir}/Sniffles2"
# SVIM_output_dir="${output_dir}/SVIM"

# mkdir -p "${CuteSV_output_dir}"
# mkdir -p "${DeBreak_output_dir}"
# mkdir -p "${Delly_output_dir}"
# mkdir -p "${Dysgu_output_dir}"
# mkdir -p "${Nanomansv_output_dir}"
# mkdir -p "${NanoVar_output_dir}"
# mkdir -p "${Savana_output_dir}"
# mkdir -p "${Severus_output_dir}"
mkdir -p "${Sniffles2_output_dir}"
# mkdir -p "${SVIM_output_dir}"

## Test Sniffles2
docker run --rm \
    --platform linux/amd64 \
    --cpus 8 \
    --memory 32g \
    --workdir /out \
    --env HOME=/tmp \
    --mount type=bind,source="${input_dir}/${input_bam}",target=/input.bam,readonly \
    --mount type=bind,source="${input_dir}/${input_bam_bai}",target=/input.bam.bai,readonly \
    --mount type=bind,source="${reference_genome}",target=/reference.fa,readonly \
    --mount type=bind,source="${reference_genome_index}",target=/reference.fa.fai,readonly \
    --mount type=bind,source="${matched_control}",target=/matched_control.bam,readonly \
    --mount type=bind,source="${Sniffles2_output_dir}",target=/output \
    --mount type=bind,source="${regions_bed}",target=/regions.bed,readonly \
    sv-callers:sniffles2-2.8.1 \
    --input /input.bam \
    --reference /reference.fa \
    --vcf /output/sniffles2_test_BED.vcf \
    --regions /regions.bed \
    --threads 8 \
    --allow-overwrite

# Quick check if the output VCF file exists. Make sure to rename or delete any previous test VCF files before running this check.
if [ -f "${Sniffles2_output_dir}/sniffles2_test_BED.vcf" ]; then
    echo "Sniffles2 run successful. Output VCF file is available at ${Sniffles2_output_dir}/sniffles2_test_BED.vcf"
else
    echo "Sniffles2 run failed. Output VCF file not found."
fi
