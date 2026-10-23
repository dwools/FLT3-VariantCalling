#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

### THIS SCRIPT HAS BEEN KEPT FOR PRESERVATION, BUT IS NO LONGER USED IN THE CURRENT WORKFLOW AS IT IS REPLACED BY s6-5_VerifyCondaPackageManifestsAndHelpOutputs.sh

# 5.3. Create image manifests

# For each variant caller image, preserve the Conda environment—that is, a manifest/inventory of the Conda package artifacts used to construct each image/environment. 

mkdir -p manifests
expected_images=(
  "sv-callers:cutesv-2.1.4"
  "sv-callers:debreak-1.3"
  "sv-callers:delly-2.7.0"
  "sv-callers:dysgu-1.9.0"
  "sv-callers:nanomonsv-0.9.0"
  "sv-callers:nanovar-1.8.3"
  "sv-callers:savana-1.3.8"
  "sv-callers:severus-1.7"
  "sv-callers:sniffles2-2.8.1"
  "sv-callers:svim-2.0.0"
)

for img in "${expected_images[@]}"; do
  echo "Generating manifests for ${img}"

  # Export exact package artifacts.
  docker run --rm --entrypoint conda "${img}" list --name sv --explicit > "manifests/${img}-linux-64-explicit.txt"

  # Export human-readble package inventory.
  docker run --rm --entrypoint conda "${img}" list --name sv > "manifests/${img}-conda-list.txt"

  echo "Completed manifests for ${img}"

done

echo "All Conda manifests have been generated successfully."
