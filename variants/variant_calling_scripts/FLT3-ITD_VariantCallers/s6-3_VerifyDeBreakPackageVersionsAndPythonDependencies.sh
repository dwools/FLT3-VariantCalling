#!/bin/bash

# 6.3. Verify package versions and Python dependencies for DeBreak

cd "$(dirname "${BASH_SOURCE[0]}")"

# 6.3.1. Due to DeBreak's not-quite-synchronized version control on the GitHub, the upstream DeBreak v1.3 entrypoint (https://github.com/ChongLab/DeBreak/blob/v1.3/debreak) still embeds a `Debreak_v1.0.2` version-reporting string. Because of this discrepancy, the version reported by the entrypoint may not match the actual DeBreak Bioconda package version installed in the environment. So we need to inspect the Conda metadata for Debreak explicitly, as shown below. The package should report `debreak 1.3`.

if ! docker run --rm --entrypoint conda sv-callers:debreak-1.3 list --name sv debreak; then
    echo "DeBreak package version verification failed."
    exit 1
elif
    docker run --rm --entrypoint conda sv-callers:debreak-1.3 list --name sv debreak | grep -q "debreak 1.3"; then
    echo "DeBreak package version is correct."
else
    echo "DeBreak package version is incorrect."
    exit 1
fi


# 6.3.2. Verify the Python environment and dependencies for DeBreak

# Verify that the DeBreak Docker image uses the Python interpreter from its dedicated Conda environment, "sv", rather than the Miniforge base environment.
#
# Also verify that pysam can be imported successfully and that the imported pysam version is 0.19.0.

if docker run --rm \
    --entrypoint /bin/bash \
    sv-callers:debreak-1.3 \
    -c '
        set -euo pipefail

        # Check 1: Verify the Python executable path.
        python_path="$(command -v python)"
        echo "Python executable: ${python_path}"

        test "${python_path}" = "/opt/conda/envs/sv/bin/python"

        # Check 2: Display the Python version selected by Conda.
        python --version

        # Check 3: Import pysam and verify its installed version.
        pysam_version="$(python -c "import pysam; print(pysam.__version__)")"
        echo "pysam version: ${pysam_version}"

        test "${pysam_version}" = "0.19.0"
    '
then
    echo "DeBreak Python environment verification succeeded."
else
    echo "DeBreak Python environment verification failed."
    exit 1
fi

# Explanation:
#
# Check 1 verifies that the runtime Python executable is located at /opt/conda/envs/sv/bin/python.
#
# Our Dockerfile contains: # ENV PATH="/opt/conda/envs/sv/bin:${PATH}". This places the application environment's bin directory before the Miniforge base environment in PATH.
#
# Checking the executable path independently confirms that the intended Python interpreter is being selected at runtime.


# Check 2 reports the Python version installed in the application environment. Conda selected this version automatically because we did not explicitly constrain Python in environment.yml.
#
# For our successfully built DeBreak image, this is Python 3.8.5. This check documents the version; it does not require 3.8.5.
#

# Check 3 verifies that the selected interpreter can successfully import pysam and that the imported version is 0.19.0.
#
# Importing pysam can detect problems such as missing shared libraries or incompatible binary components that would not necessarily be revealed by inspecting Conda package records.
#
# These checks verify the basic Python runtime configuration and one important dependency. They do not establish that the full DeBreak application performs structural variant calling correctly.


# For good measure, verify that the Sniffles2 image contains the expected Conda package.

if docker run --rm \
    --entrypoint /bin/bash \
    sv-callers:sniffles2-2.8.1 \
    -c '
        set -euo pipefail

        conda list --name sv --full-name sniffles |
        grep -Eq "^sniffles[[:space:]]+2[.]8[.]1([[:space:]]|$)"
    '
then
    echo "Sniffles2 package verification succeeded."
else
    echo "Sniffles2 package verification failed."
    exit 1
fi

# This checks that Conda reports the package named "sniffles", version 2.8.1, in the dedicated "sv" environment. It is an installed-package verification, not a functional test of the Sniffles2 structural variant caller.
