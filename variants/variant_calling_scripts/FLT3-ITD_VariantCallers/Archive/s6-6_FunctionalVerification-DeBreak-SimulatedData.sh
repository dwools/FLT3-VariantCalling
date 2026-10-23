#!/bin/bash

################################################################################################
### THIS SCRIPT HAS BEEN KEPT FOR PRESERVATION, BUT IS NO LONGER PART OF THE MAIN VERIFICATION WORKFLOW, AS REDUCED-SCALE TESTING WILL BE PERFORMED ON A SUBSET OF THE DATA FOR ALL CALLERS
################################################################################################

# 6.6. Functional verification of DeBreak with the v1.3 GitHub release's simulated dataset (DeBreak v1.3 GitHub release: https://github.com/ChongLab/DeBreak)
    # DeBreak's v1.3 GitHub release's README describes a simulated ~ 450-kbp reference containing six structural variants and a corresponding BAM, reference FASTA, and expected VCF. Use the GitHub's `v1.3` tag for the reference files; the README's historical source-clone command still mentions the v1.2 repository.


## 6.6.1. Get the test files (Ubuntu host, Git required)
cd ~/sv-callers-docker

mkdir -p verification
git clone --branch v1.3 --depth 1 \
  https://github.com/ChongLab/DeBreak.git \
  verification/debreak-v1.3-source
ls -lh verification/debreak-v1.3-source/testdata/

## 6.6.2. Confirm the actual expected files before continuing (if unavailable, stop and troubleshoot, rather than inventing substitute filenames):

TESTDATA="$PWD/verification/debreak-v1.3-source/testdata"
test -f "$TESTDATA/test_read.bam"
test -f "$TESTDATA/test_ref.fa"
test -f "$TESTDATA/debreak.vcf"


## 6.6.3. Prepare the BAM for DeBreak
  ## DeBreak requires an indexed, coordinate-sorted BAM. Preserve the upstream test dataset by making a writable working copy, and create an index only if needed. The index step invokes the samtools already supplied by the DeBreak image; no host-level installation is needed:

# Ubuntu host, project root
cd ~/sv-callers-docker
cp -a verification/debreak-v1.3-source/testdata \
  verification/debreak-v1.3-input

BAMBASE="verification/debreak-v1.3-input/test_read.bam"
if [[ ! -f "${BAMBASE}.bai" && ! -f "${BAMBASE%.bam}.bai" && ! -f "${BAMBASE}.csi" ]]; then
  docker run --rm \
    --user "$(id -u):$(id -g)" \
    --entrypoint samtools \
    --mount "type=bind,src=${PWD}/verification/debreak-v1.3-input,dst=/data" \
    sv-callers:debreak-1.3 \
    index /data/test_read.bam
fi

# If indexing fails, check BAM sort order and dataset integrity before running DeBreak. Repeat this test in a fresh directory if you need to rerun the instructions; cp -a should not be used to merge into an existing copy unintentionally.


## 6.6.4. Run DeBreak on the prepared test dataset
cd ~/sv-callers-docker
mkdir -p verification/debreak-v1.3-test-output

docker run --rm \
  --platform linux/amd64 \
  --cpus 4 \
  --memory 4g \
  --user "$(id -u):$(id -g)" \
  --env HOME=/tmp \
  --workdir /out \
  --mount "type=bind,src=${PWD}/verification/debreak-v1.3-input,dst=/data,readonly" \
  --mount "type=bind,src=${PWD}/verification/debreak-v1.3-test-output,dst=/out" \
  sv-callers:debreak-1.3 \
  --bam /data/test_read.bam \
  --outpath /out \
  --poa \
  --rescue_large_ins \
  --rescue_dup \
  --ref /data/test_ref.fa \
  --thread 4

# This follows the documented full-featured test with container mounts. --thread 4 and -t 4 are equivalent according to Repo2's CLI. The 4g memory limit is a container setting, not a claim of observed memory usage.


## 6.6.5. Inspect the DeBreak output files to confirm expected results
ls -lh verification/debreak-v1.3-test-output/
head -n 30 verification/debreak-v1.3-test-output/debreak.vcf

diff -u \
  verification/debreak-v1.3-source/testdata/debreak.vcf \
  verification/debreak-v1.3-test-output/debreak.vcf

# DeBreak's v1.3 GitHub release's README says the test calls should match the reference. An exact diff is a first check, not always a robust semantic VCF comparison: headers, record ordering, or formatting may differ despite equivalent calls. If it differs, compare normalized SV records and investigate biologically meaningful differences before deciding whether the test passed.

# Functional verification for the other nine callers: Supply appropriate documented small test data for each caller when approving an image for scientific work. CLI help alone is insufficient to establish successful calling.




