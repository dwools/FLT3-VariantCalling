#!/bin/bash

# This script will be a collection of commands for calling structural variants in FLT3 amplicon sequencing data using nanopore reads using various structural variant callers. The variant callers included are: cuteSV, DeBreak, Delly, Dysgu, Nanomansv, NanoVar, Savana, Severus, Sniffles2, and SVIM. Each caller will have its own section with the necessary commands and parameters for running it on the data. Each caller will use the same input, reference genome, and matched control samples. All callers will be executed using the matched control sample for accurate variant calling. Each variant caller will have a dedicated output directory for storing its results. Within the script, each caller will have its own section containing installiation instructions (especially whether the caller can be run in a container) and commands to execute the variant calling process. This script does not assume any prior installation or setup of the variant callers or their dependencies and aims to provide a comprehensive and reproducible workflow for structural variant calling in FLT3 amplicon sequencing data.

# Each variant caller's run should also record metrics for performance evaluation, such as runtime, memory usage, CPU usage, and disk I/O.

# If I hope to compare the performance of the variant callers included in this script, with such metrics as runtime, memory usage, CPU usage, and disk I/O, does it matter if some of the callers are run in containers while others are run natively



input_dir="/mnt/pikachu/dwools/flt3/nanopore_FLT3_20240621_Flt3_amplicon_B/barcode_bam_files/101060b6-feca-40e4-807d-eb79553bafe8_SQK-NBD114-24_barcode01.bam"
reference_genome="/mnt/pikachu/dwools/flt3/nanopore_FLT3_20240621_Flt3_amplicon_B/genome/GRCh38_primary_assembly_genome.fa"
matched_control="/mnt/pikachu/dwools/flt3/nanopore_FLT3_20240621_Flt3_amplicon_B/matchedControl_gm24385_2023.12/matchedControl_gm24385_flt3/matchedControl_gm24385_flt3.bam"
output_dir="/mnt/pikachu/dwools/flt3/nanopore_FLT3_20240621_Flt3_amplicon_B/variants/flt3-itd_results"

cuteSV_output_dir="${output_dir}/cuteSV"
DeBreak_output_dir="${output_dir}/DeBreak"
Delly_output_dir="${output_dir}/Delly"
Dysgu_output_dir="${output_dir}/Dysgu"
Nanomansv_output_dir="${output_dir}/Nanomansv"
NanoVar_output_dir="${output_dir}/NanoVar"
Savana_output_dir="${output_dir}/Savana"
Severus_output_dir="${output_dir}/Severus"
Sniffles2_output_dir="${output_dir}/Sniffles2"
SVIM_output_dir="${output_dir}/SVIM"



############################
########## cuteSV ##########
############################
# Installation
# cuteSV does not have a containerized version. The documentation recommends installing it via Conda.
conda install -c bioconda cutesv

# Dependencies for cuteSV:
    # 1. python3
    # 2. scipy
    # 3. pysam
    # 4. Biopython
    # 5. cigar
    # 6. numpy
    # 7. pyvcf3
    # 8. scikit-learn



#############################
########## DeBreak ##########
#############################
# Installation
# DeBreak does not have a containerized version. The documentation recommends installing it via Conda.
conda create --name deb
conda activate deb
conda install -c bioconda debreak

# Dependencies for DeBreak:
    # python3
    # pysam (tested with version 0.19.0)
    # minimap2 (tested with version 2.15)
    # wtdbg2 (tested with version 2.5)
    # bsalign (tested with version 1.2.1)



###########################
########## Delly ##########
###########################
# Installation
# Delly can run in a containerized environment using Docker.
docker pull dellytools/delly



###########################
########## Dysgu ##########
###########################
# Installation
# Dysgu can run in a containerized environment using Docker.
docker pull kcleal/dysgu



###############################
########## nanomonsv ##########
###############################
# Installation
# nanomonsv can run in a containerized environment using Docker.
docker pull friend1ws/nanomonsv


#############################
########## NanoVar ##########
#############################
# Installation
# NanoVar does not have a containerized version. The documentation recommends installing it via Conda.
conda create -n myenv -c bioconda python=3.11 samtools bedtools minimap2
conda activate myenv
pip install nanovar

# or

conda create -n myenv -c bioconda python=3.11 nanovar
conda activate myenv

# Dependencies for NanoVar:
    # bedtools >=2.26.0
    # samtools >=1.3.0
    # minimap2 >=2.17



############################
########## Savana ##########
############################
# Installation
# Savana does not have a containerized version. The documentation recommends installing it via Conda.
conda install -c bioconda savana



#############################
########## Severus ##########
#############################
# Installation
# Severus does not have a containerized version. The documentation recommends installing it via Conda.
conda create -n severus_env severus
conda activate severus_env
severus --help



###############################
########## Sniffles2 ##########
###############################
# Installation
# Sniffles2 does not have a containerized version. The documentation recommends installing it via Conda.
conda install sniffles=2.8.1

# Dependencies for Sniffles2:
    # Python ==3.10.15
    # pysam >=0.21.0
    # edlib >=1.3.9
    # psutil>=5.9.4
    # numpy>=2.2.0
    # pyspoa>=0.2.1



##########################
########## SVIM ##########
##########################
# Installation
# SVIM does not have a containerized version. The documentation recommends installing it via Conda.
conda install -c bioconda svim

# Dependencies for SVIM:
    # edlib for edit distance computation
    # matplotlib>=3.3.0 for plotting
    # numpy and scipy for hierarchical clustering
    # pysam (>=0.15.2) for SAM/BAM file processing
    # pyspoa (>=0.0.6) for consensus sequence computation
    # py-cpuinfo (>=7.0.0) for CPU info retrieval (checking for SIMD capabilities)

