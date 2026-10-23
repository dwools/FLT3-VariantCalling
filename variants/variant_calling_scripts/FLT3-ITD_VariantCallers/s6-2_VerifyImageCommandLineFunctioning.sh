#!/bin/bash

# 6.2. Smoke tests: Check proper function of each SV caller Docker image's command-line interface

# This script verifies that each SV caller's command-line interface is functioning correctly with expected input, output, and behavior. This is done in a for loop through the array of SV caller images. At each iteration, the image's command-line interface is tested by running the image's `--help` command and checking whether the invocation returns exit status zero. The `--help` output is written to a log file for inspection. Images returning nonzero statuses are reported for further investigation. These checks provide preliminary CLI smoke testing, not confirmation of correct help output or complete application functionality.

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
mkdir -p verification

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
unexpected_cli_images=()

for img in "${sv_callers[@]}"; do
    echo "Verifying command-line interface for $img..."
    if docker run --rm \
    --platform linux/amd64 \
    "sv-callers:$img" --help \
    > "verification/${img}-help.log" 2>&1
then
    echo "CLI invocation succeeded for $img"
else
    echo "Unexpected CLI exit status for $img"
    all_correct=false
    unexpected_cli_images+=("$img")
fi
done

if [ "$all_correct" = true ]; then
    echo "All SV caller Docker images passed the command-line interface verification."
else
    echo "The following images exhibited unexpected behavior:"
    for img in "${unexpected_cli_images[@]}"; do
        echo "  $img"
    done
    exit 1
fi
