#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

#### Call scripts #####

./s6-1_ConfirmImageArchitecture.sh
./s6-2_VerifyImageCommandLineFunctioning.sh
./s6-3_VerifyDeBreakPackageVersionsAndPythonDependencies.sh
./s6-4_VerifyDeBreakBundledBsalineAndOtherExecutables.sh
./s6-5_VerifyCondaPackageManifestsAndHelpOutputs.sh
