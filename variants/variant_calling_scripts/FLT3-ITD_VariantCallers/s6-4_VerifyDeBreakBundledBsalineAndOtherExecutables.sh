#!/bin/bash

# 6.4. Verify DeBreak's bundled `bsalign` and other executables. 

cd "$(dirname "${BASH_SOURCE[0]}")"

# 6.4.1. Verify DeBreak executable and dependency availability.
# Verify that DeBreak and its required command-line tools are discoverable in the dedicated "sv" Conda environment.
#
# The DeBreak Bioconda package installs "debreak" and its bundled "bsalign" executable. Conda installs minimap2, samtools, and wtdbg2 through DeBreak's runtime dependencies.
#
# All five commands are expected to resolve to executables in /opt/conda/envs/sv/bin/.

if docker run --rm \
    --entrypoint /bin/bash \
    sv-callers:debreak-1.3 \
    -c '
        set -euo pipefail

        expected_dir="/opt/conda/envs/sv/bin"

        for tool in debreak bsalign minimap2 samtools wtdbg2; do

            # Determine the executable selected by PATH.
            actual_path="$(command -v "$tool")"

            echo "${tool}: ${actual_path}"

            # Verify that the executable comes from the
            # expected Conda environment.
            test "${actual_path}" = "${expected_dir}/${tool}"

            # Verify that the resolved path is an executable file.
            test -f "${actual_path}"
            test -x "${actual_path}"

        done
    '
then
    echo "DeBreak executable availability verification succeeded."
else
    echo "DeBreak executable availability verification failed."
    exit 1
fi

# Explanation:
# The "command -v" command determines which executable Bash would use when the specified command is invoked.
#
# Our Dockerfile contains:
# ENV PATH="/opt/conda/envs/sv/bin:${PATH}"
#
# This configuration places the dedicated "sv" environment's executable directory before Miniforge's base environment.
#
# Merely finding a command would not establish that it comes from the intended environment. We therefore compare each resolved executable path with its expected path under /opt/conda/envs/sv/bin/.
#
# The "test -f" command confirms that the resolved path is an existing regular file, and "test -x" confirms that it has executable permission.
#
# The "set -euo pipefail" instruction makes Bash terminate when an unchecked command fails, an unset variable is used, or a pipeline fails.
#
# If all checks pass, we know that the specified tools are discoverable and accessible in the intended Conda environment.
#
# IMPORTANT:
# These checks do not actually execute the tools. They do not verify that the tools can start, load their shared libraries, or successfully perform their intended biological analyses.


# 6.4.2. Verify basic execution of the bundled bsalign binary.
# Execute the prebuilt bsalign program and check for the identification signature used by the DeBreak Bioconda recipe.
#
# Because bsalign is invoked without required arguments, a nonzero exit status may be normal. For this particular smoke test, we therefore check its output signature rather than requiring a zero exit status.

if docker run --rm \
    --entrypoint /bin/bash \
    sv-callers:debreak-1.3 \
    -c '
        set -euo pipefail

        # Capture standard output and standard error.
        # Permit a nonzero status from this no-argument invocation.
        output="$(bsalign 2>&1)" || true

        # Print the output for inspection.
        printf "%s\n" "$output"

        # Require the expected identification signature.
        grep -Fq "Program: bsalign" <<< "$output"
    '
then
    echo "DeBreak bundled bsalign execution verification succeeded."
else
    echo "DeBreak bundled bsalign execution verification failed."
    exit 1
fi

# Explanation:
# Section 6.4.1 established that the bsalign executable exists and is discoverable in the intended Conda environment. Here, we go one step further by attempting to execute it.
#
# The "2>&1" redirection captures both standard output and standard error. This matters because a command invoked without arguments may print usage or identification information to either output stream.
#
# The identifying text "Program: bsalign" is the signature used in the official DeBreak Bioconda test recipe.
#
# "grep -Fq" searches for that exact literal string. Its exit status is 0 when the string is found and nonzero when the string is absent.
#
# The "|| true" clause deliberately tolerates a nonzero exit status from bsalign itself, since invoking it without mandatory arguments may produce an error status even when the executable starts successfully and prints usage text.
#
# The verification succeeds only if the expected signature appears in bsalign's output.
#
# A successful result provides evidence that the prebuilt native executable can start and reach its identification or usage-reporting code on this container's Linux platform.
#
# It does not establish that bsalign can successfully perform real sequence alignment or that DeBreak's complete analysis pipeline works correctly.



# 6.4.3. Inspect dynamic-library dependencies of bsalign.
# For dynamically linked executables, verify that ldd does not report any unresolved shared-library dependencies.
#
# A statically linked executable may report that it is not dynamically linked. This is not automatically a failure.
#
# Section 6.4.2 separately verifies that bsalign can execute and produce its expected identification message.

if docker run --rm \
    --entrypoint /bin/bash \
    sv-callers:debreak-1.3 \
    -c '
        set -euo pipefail

        # Locate bsalign in the application environment.
        binary="$(command -v bsalign)"

        echo "Inspecting: ${binary}"

        # Capture ldd output and exit status.
        ldd_status=0
        ldd_output="$(ldd "$binary" 2>&1)" || ldd_status=$?

        printf "%s\n" "$ldd_output"

        # Reject unresolved shared-library dependencies.
        if grep -Fq "not found" <<< "$ldd_output"; then
            echo "ERROR: Unresolved shared-library dependency."
            exit 1
        fi

        # Recognize common static-linking reports.
        if grep -Eq \
            "not a dynamic executable|statically linked" \
            <<< "$ldd_output"; then

            echo "No dynamic-library dependency check is needed."
            echo "Refer to the bsalign execution test in Section 6.4.2."
            exit 0
        fi

        # Reject unexpected ldd failures.
        if test "$ldd_status" -ne 0; then
            echo "ERROR: ldd failed unexpectedly."
            exit 1
        fi

        echo "No unresolved dynamic-library dependencies reported."
    '
then
    echo "DeBreak bsalign linking inspection succeeded."
else
    echo "DeBreak bsalign linking inspection failed."
    exit 1
fi

# Explanation:
# Section 6.4.1 established that the bsalign executable exists. Section 6.4.2 tested whether the executable can start.
#
# Here, we investigate whether a dynamically linked bsalign executable has unresolved shared-library dependencies.
#
# The "ldd" command lists the shared libraries required by a dynamically linked executable and where they are found.
#
# The command "command -v bsalign" selects the executable currently resolved through PATH.
#
# We capture ldd's output and its exit status separately. This allows us to distinguish ordinary linking information from unresolved libraries and unexpected ldd failures.
#
# If a required library cannot be located, ldd commonly reports that library followed by "not found".
#
# We explicitly search for that phrase and fail the test if it appears.
#
# A statically linked executable may instead produce a message such as "not a dynamic executable".
#
# That message is not treated as an error, because static executables do not require ordinary dynamic linking for their statically incorporated libraries.
#
# Successful execution in Section 6.4.2 provides a useful independent check that bsalign can start.
#
# IMPORTANT:
# The absence of unresolved libraries does not establish that the executable performs correct sequence alignment. Full functional validation still requires running DeBreak on an appropriate test dataset.

