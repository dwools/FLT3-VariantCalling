#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

# Part 5: Building the SV caller Docker images for all SV callers

    # Main script to execute all build steps for SV caller Docker images

# Execute all build steps for building the SV caller Docker images
./s5-1_BuildVariantCallerDockerImages.sh
./s5-2_ConfirmDockerImageCreation.sh