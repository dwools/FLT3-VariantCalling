#!/usr/bin/env bash

# 6.5. Record Conda package inventories and capture CLI help output for all structural variant callers.
# This script creates two Conda inventory files for each Docker image:
#
# 1. An explicit package specification recording the exact Conda package artifacts installed in the "sv" environment.
#
# 2. A human-readable package inventory recording installed package names, versions, builds, and channels.
#
# These files document the resolved software environments for reproducibility. They are not independent tests of whether Conda
# installed the versions originally requested.

# Failed commands print warnings but do not stop the script or necessarily cause it to exit with a nonzero status.
#
# Consequently, successful script completion must not be interpreted as successful verification of every Docker image.
#
# End-to-end functional validation requires running the callers against appropriate input data and evaluating the resulting outputs.

cd "$(dirname "${BASH_SOURCE[0]}")"
mkdir -p manifests

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

failed=0

for caller in "${sv_callers[@]}"; do
    echo "== Checking ${caller} =="

    docker run --rm --platform linux/amd64 --entrypoint conda "sv-callers:${caller}" list --name sv --explicit > "manifests/${caller}-linux-64-explicit.txt" || {
    echo "ERROR: package manifest failed for ${caller}" >&2
    failed=1
}

    docker run --rm --platform linux/amd64 --entrypoint conda "sv-callers:${caller}" list --name sv > "manifests/${caller}-conda-list.txt" || {
    echo "ERROR: conda list failed for ${caller}" >&2
    failed=1
}

done

if (( failed != 0 )); then
    echo "One or more Conda inventory exports failed." >&2
    exit 1
fi

echo "All Conda inventories exported successfully."
echo "Inspect the help logs and verify that installed versions match the manifests."

# **Caveat:** The script prints warnings for failed commands and can still finish without a nonzero final exit status. Do not interpret its completion as an all-pass result. Inspect logs and package inventories, especially for callers whose CLI returns a nonzero exit status for `--help`:
