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
sample_name="barcode1"

########################################
##### Docker images, for reference #####
########################################

# sv-callers:cutesv-2.1.4
# sv-callers:debreak-1.3
# sv-callers:delly-2.7.0
# sv-callers:dysgu-1.9.0
# sv-callers:nanomonsv-0.9.0
# sv-callers:nanovar-1.8.3
# sv-callers:savana-1.3.8
# sv-callers:severus-1.7
# sv-callers:sniffles2-2.8.1
# sv-callers:svim-2.0.0

# Delly_output_dir="${output_dir}/Delly"
# Dysgu_output_dir="${output_dir}/Dysgu"
# Nanomansv_output_dir="${output_dir}/Nanomansv"
# NanoVar_output_dir="${output_dir}/NanoVar"
# Savana_output_dir="${output_dir}/Savana"
# Severus_output_dir="${output_dir}/Severus"
# Sniffles2_output_dir="${output_dir}/Sniffles2"




# mkdir -p "${Delly_output_dir}"
# mkdir -p "${Dysgu_output_dir}"
# mkdir -p "${Nanomansv_output_dir}"
# mkdir -p "${NanoVar_output_dir}"
# mkdir -p "${Savana_output_dir}"
# mkdir -p "${Severus_output_dir}"
# mkdir -p "${Sniffles2_output_dir}"

test_cutesv() {
	# Note 1: CuteSV's `work_dir` argument specifies the "working directory" where intermediate files are stored during the run. It must already exist before running the command, and it must be empty because cuteSV refuses to overwrite some temporary outputs (source: https://github.com/taffish/cutesv, an auxilliary GitHub repository).

	# Note 2: The CuteSV README (https://github.com/tjiangHIT/cuteSV#usage) recommends these parameters for ONT data:
		# --max_cluster_bias_INS 100 \
		# --diff_ratio_merging_INS 0.3 \
		# --max_cluster_bias_DEL 100 \
		# --diff_ratio_merging_DEL 0.3 \

	CuteSV_output_dir="${output_dir}/CuteSV"
	mkdir -p "${CuteSV_output_dir}"

	docker run --rm \
    --platform linux/amd64 \
    --cpus 8 \
    --memory 32g \
    --env HOME=/tmp \
	--workdir /out \
    --mount type=bind,source="${input_dir}/${input_bam}",target=/input.bam,readonly \
    --mount type=bind,source="${input_dir}/${input_bam_bai}",target=/input.bam.bai,readonly \
    --mount type=bind,source="${reference_genome}",target=/reference.fa,readonly \
    --mount type=bind,source="${reference_genome_index}",target=/reference.fa.fai,readonly \
    --mount type=bind,source="${regions_bed}",target=/regions.bed,readonly \
    --mount type=bind,source="${CuteSV_output_dir}",target=/output \
    sv-callers:cutesv-2.1.4 \
    /input.bam \
	/reference.fa \
    /output/cutesv_test.vcf \
    /work \
	--sample "${sample_name}"\
	--max_cluster_bias_INS 100 \
	--diff_ratio_merging_INS 0.3 \
	--max_cluster_bias_DEL 100 \
	--diff_ratio_merging_DEL 0.3 \
    -include_bed /regions.bed


	# Quick check if the output VCF file exists. Make sure to rename or delete any previous test VCF files before running this check.
	if [ -f "${CuteSV_output_dir}/cutesv_test.vcf" ]; then
		echo "CuteSV run successful. Output VCF file is available at ${CuteSV_output_dir}/cutesv_test.vcf"
	else
		echo "CuteSV run failed. Output VCF file not found."
	fi
}

test_debreak() {

	# DeBreak's output consists of a directory containing the following files:

		# debreak.vcf                   Standard VCF file of SV calls. The chromosome, coordinates, size, type, number of supporting reads, mapping quality, genotype, and multi-allelic information are recorded for each SV call.
		# debreak-allsv-merged-final    Tab-delimited SV list, containing the name of reads supporting each SV call.
		# sv_raw_calls/                 Includes all SV raw signals on each chromosome.
		# debreak_poa_workspace/        Temporary files during SV breakpoint refinement with POA. For debug purpose.
		# debreak_ins_workspace/        Temporary files during ultra-large insertion detection. For debug purpose.
		# map_depth/                    Temporary files during sequencing depth estimation. For debug purpose.

	DeBreak_output_dir="${output_dir}/DeBreak"
	mkdir -p "${DeBreak_output_dir}"

	docker run --rm \
	--platform linux/amd64 \
	--cpus 8 \
	--memory 32g \
	--env HOME=/tmp \
	--workdir /out \
	--mount type=bind,source="${input_dir}/${input_bam}",target=/input.bam,readonly \
	--mount type=bind,source="${input_dir}/${input_bam_bai}",target=/input.bam.bai,readonly \
	--mount type=bind,source="${reference_genome}",target=/reference.fa,readonly \
	--mount type=bind,source="${reference_genome_index}",target=/reference.fa.fai,readonly \
	--mount type=bind,source="${DeBreak_output_dir}",target=/output \
	sv-callers:debreak-1.3 \
	--bam /input.bam \
	--out /output\
	--rescue_large_ins \
	--rescue_dup \
	--poa \
	--ref /reference.fa \
	--tumor
	
	# Quick check if the output VCF file exists. Make sure to rename or delete any previous test VCF files before running this check.
	if [ -f "${DeBreak_output_dir}/debreak.vcf" ]; then
		echo "DeBreak run successful. Output files are available at ${DeBreak_output_dir}"
	else
		echo "DeBreak run failed. Output VCF file not found."
	fi

	# Track any files > 100 MB with Git LFS.
	find "${DeBreak_output_dir}" -type f -size +100M -exec git lfs track "{}" \;
	
}

test_sniffles2() {
	
	Sniffles2_output_dir="${output_dir}/Sniffles2"
	mkdir -p "${Sniffles2_output_dir}"

	docker run --rm \
    --platform linux/amd64 \
    --cpus 8 \
    --memory 32g \
    --env HOME=/tmp \
    --mount type=bind,source="${input_dir}/${input_bam}",target=/input.bam,readonly \
    --mount type=bind,source="${input_dir}/${input_bam_bai}",target=/input.bam.bai,readonly \
    --mount type=bind,source="${reference_genome}",target=/reference.fa,readonly \
    --mount type=bind,source="${reference_genome_index}",target=/reference.fa.fai,readonly \
    --mount type=bind,source="${regions_bed}",target=/regions.bed,readonly \
    --mount type=bind,source="${Sniffles2_output_dir}",target=/output \
    sv-callers:sniffles2-2.8.1 \
    --input /input.bam \
    --reference /reference.fa \
    --vcf /output/sniffles2_test.vcf \
    --regions /regions.bed \
    --allow-overwrite

	# Quick check if the output VCF file exists. Make sure to rename or delete any previous test VCF files before running this check.
	if [ -f "${Sniffles2_output_dir}/sniffles2_test.vcf" ]; then
		echo "Sniffles2 run successful. Output VCF file is available at ${Sniffles2_output_dir}/sniffles2_test.vcf"
	else
		echo "Sniffles2 run failed. Output VCF file not found."
	fi
}

test_svim() {

	SVIM_output_dir="${output_dir}/SVIM"
	rm -f ${SVIM_output_dir}/*.log
	mkdir -p ${SVIM_output_dir}

	if docker run --rm \
    --platform linux/amd64 \
    --cpus 8 \
    --memory 32g \
    --env HOME=/tmp \
	--workdir /out \
    --mount type=bind,source="${input_dir}/${input_bam}",target=/input.bam,readonly \
    --mount type=bind,source="${input_dir}/${input_bam_bai}",target=/input.bam.bai,readonly \
    --mount type=bind,source="${reference_genome}",target=/reference.fa,readonly \
    --mount type=bind,source="${reference_genome_index}",target=/reference.fa.fai,readonly \
    --mount type=bind,source="${SVIM_output_dir}",target=/output \
	sv-callers:svim-2.0.0 \
	alignment \
	--verbose \
	/output \
	/input.bam \
	/reference.fa \
	--sample "${sample_name}"; then
		echo "SVIM run successful. Output files are available at ${SVIM_output_dir}"
	else
		local svim_status=$?
		echo "SVIM run failed (exit status ${svim_status})." >&2
		return "${svim_status}"
	fi


	# Track any files > 100 MB with Git LFS.
	find "${SVIM_output_dir}" -type f -size +100M -exec git lfs track --filename "{}" \;
}
run_container_terminal() {
	# Sample command to run the container in interactive terminal mode for debugging or manual execution of commands inside the container.
	docker run --rm -it \
	--platform linux/amd64 \
	--cpus 8 \
	--memory 32g \
	--env HOME=/tmp \
	--entrypoint /bin/bash \
	sv-callers:sniffles2-2.8.1
}


# test_cutesv
# test_debreak
# test_sniffles2
test_svim
