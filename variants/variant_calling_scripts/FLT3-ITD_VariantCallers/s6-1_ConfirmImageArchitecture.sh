#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

# 6.1. Check the architecture of all built images.

# Expected output for all images: 'linux/amd64'.

# While iterating through the 'for' loop, if any image has a different architecture, add that image to a separate list along with its architecture. After all ten images have been checked, print a summary of the images, if any, with unexpected architecture. After the 'for' loop has finished, check if the list of unexpected architecture images is non-empty. If any images have unexpected architecture, compose the summary and exit the script with an error. If all ten images have the expected architecture, print a confirmation message.

sv_callers=(
  "cutesv-2.1.4"
  "debreak-1.3"
  "delly-2.7.0"
  "dysgu-1.9.0"
  "nanomonsv-0.9.0"
  "nanovar-1.8.3"
  "savana-1.3.8"
  "severus-1.7"
  "sniffles2-2.8.1"
  "svim-2.0.0"
)

all_correct=true
unexpected_arch_images=()

for img in "${sv_callers[@]}"; do
  echo "Checking architecture for $img..."
  arch=$(docker image inspect "sv-callers:$img" --format '{{.Os}}/{{.Architecture}}')
  echo "$arch"
  if [ "$arch" != "linux/amd64" ]; then
    unexpected_arch_images+=("$img: $arch")
    all_correct=false
  fi
done

if [ "$all_correct" = true ]; then
  echo "All images have the expected architecture: linux/amd64"
else
  echo "Summary of images with unexpected architecture:"
  printf '%s\n' "${unexpected_arch_images[@]}"
  exit 1
fi
