# Role and Expertise

You are an expert bioinformatician specializing in long-read sequencing, structural variant (SV) detection, Linux systems administration, Bash scripting, Conda package management, and Docker containerization.

You have particular expertise in designing robust, independently executable Bash scripts, orchestrating multistep workflows, implementing error handling and reporting, and verifying bioinformatics software installations.

# Objective

I would like your assistance reviewing, revising, and finalizing the Bash scripts and documentation used to build and verify ten SV caller Docker images.

The objectives are to:

1. Ensure the building and verification scripts are technically correct, robust, clearly organized, well annotated, and maintainable.
2. Ensure each building and verification step has well-defined success and failure criteria.
3. Implement reliable orchestration, error handling, and detailed results reporting.
4. Verify software installation, configuration, package versions, image architecture, executable availability, and basic runtime functionality to the extent possible without sequencing datasets.
5. Update the Installation Guide to accurately reflect the finalized scripts and procedures.

**Scope limitation:** This request concerns Docker image building and installation/runtime verification only. It does not include executing SV callers against sequencing datasets, evaluating variant calls, or establishing scientific accuracy. Dataset-based functional validation will be addressed in a separate request.

# Environment and Existing Status

The Docker images are intended for a remote Ubuntu 22.04.5 LTS server using x86_64 architecture, corresponding to Docker platform `linux/amd64`.

Each SV caller is installed in an independent Docker image using Conda, with its application environment named `sv` and located at `/opt/conda/envs/sv`.

All ten Docker images have already been built and are available on the remote server. However, I am willing to rebuild individual images if your review identifies necessary changes to their build procedures.

Do not assume that the images have passed runtime verification merely because their Docker builds completed.

Do not assume that you have direct access to the remote Docker daemon or its images. Distinguish between checks you can perform on the attached scripts and checks that I must execute on the remote server.

# Reference Materials

I have attached the Installation Guide and all current building and verification scripts.

The Installation Guide was originally produced in another ChatGPT conversation titled "Installing SV Callers." Since then, I have revised several scripts. Consequently, the Installation Guide may contain outdated commands, descriptions, filenames, and verification procedures.

The ten Dockerfile and Conda environment recipes are documented in Part 4 of the Installation Guide. These recipes provide the intended image configurations, although the actual Dockerfiles and `environment.yml` files are not separately attached.

## Attachments

**Installation Guide**

- `SV_Caller_Docker_Installation_Guide_REVISED.md`

**Building scripts — Part 5**

- `s5_build-main.sh`
- `s5-1_BuildVariantCallerDockerImages.sh`
- `s5-2_ConfirmDockerImageCreation.sh`

**Verification scripts — Part 6**

- `s6_verify-main.sh`
- `s6-1_ConfirmImageArchitecture.sh`
- `s6-2_VerifyImageCommandLineFunctioning.sh`
- `s6-3_VerifyDeBreakPackageVersionsAndPythonDependencies.sh`
- `s6-4_VerifyDeBreakBundledBsalineAndOtherExecutables.sh`
- `s6-5_VerifyCondaPackageManifestsAndHelpOutputs.sh`

Some uploaded filenames may contain automatically added suffixes such as `(1)` or `(2)`. Use the actual attached files as your inputs and produce consistently named final scripts. Ensure that the main scripts reference the correct finalized filenames.

If a filename contains a descriptive typo or no longer reflects the script's functionality, recommend a correction, but ensure all references remain consistent.

# General Requirements

1. Carefully read and review all attached materials before proposing or implementing revisions.

2. Treat the current scripts as the primary reference for the implemented workflow. Update the Installation Guide to reflect the finalized scripts rather than forcing the scripts to follow obsolete instructions.

3. However, do not assume that existing script behavior is necessarily correct. Identify and correct defects, inconsistencies, missing checks, and unreliable error-handling behavior.

4. Preserve the existing overall organization, naming conventions, logical workflow, and numbering wherever practical. Avoid unnecessary restructuring or additional dependencies.

5. Ensure that every script is independently executable and can also be invoked by its corresponding main orchestration script.

6. Design scripts for safe repeated execution. Avoid unintended destructive operations, distinguish current execution results from artifacts of previous runs, and handle missing prerequisites appropriately.

7. Favor readable, maintainable Bash code over unnecessarily complex abstractions. Use Bash built-ins and standard Linux utilities wherever practical.

8. Clearly distinguish among:
   - Docker image creation and image metadata verification.
   - Conda package installation and version verification.
   - Executable availability and dependency checks.
   - Basic command-line/runtime smoke tests.
   - Reproducibility information collection.
   - Dataset-based scientific functional validation, which is outside the current scope.

9. Do not describe a check as providing stronger evidence than it actually provides. For example, exporting a Conda package manifest documents the installed environment but does not independently prove that the environment matches its intended specification.

10. If official documentation or upstream source code must be consulted to resolve uncertain technical behavior, favor authoritative sources and distinguish verified information from assumptions.

# Part 5 — Building the Docker Images

## Definition of a Building Step

A building step is a clearly defined operation within the Docker image building workflow.

Each building step must specify or otherwise make clear its prerequisites, operation, expected result, and criteria for success or failure.

A building script should represent one coherent stage of the building workflow. It may contain multiple independently reportable substeps when those operations logically belong together.

For example, `s5-1_BuildVariantCallerDockerImages.sh` builds all ten images. Preserve this organization if practical, but treat each individual image build as a separately reportable substep.

## Individual Building Scripts

Review and revise both individual building scripts.

### 5.1 Build Each Image

Update `s5-1_BuildVariantCallerDockerImages.sh` so that:

- All ten images are attempted during a normal build run, even if one or more builds fail.
- Every image build has an independently recorded outcome.
- Failures are clearly associated with the affected caller and Docker image tag.
- The script produces a summary of successful and failed image builds.
- A failed build does not incorrectly count as successful merely because an image with the same tag already exists from a previous build.
- The script returns a nonzero exit status if one or more required builds fail.

Where useful, identify the individual caller builds as substeps `5.1.1` through `5.1.10`.

### 5.2 Confirm Docker Image Creation

Review `s5-2_ConfirmDockerImageCreation.sh` to ensure that:

- All ten expected image tags are checked.
- Missing images are reported individually.
- Docker command errors are handled correctly.
- The check does not confuse image presence with successful completion of a new build.
- The script reports its results and returns an appropriate exit status.

## Main Building Script

Review and revise `s5_build-main.sh`.

The main script must:

- Execute the individual building scripts in the intended order.
- Capture their results and exit statuses.
- Report which building steps and individual image builds succeeded or failed.
- Continue to execute independent steps after recoverable failures.
- Recognize when a step cannot meaningfully proceed because a prerequisite failed.
- Provide an overall build summary.
- Return a nonzero exit status if any required building step fails.

Error handling must not conceal failures or incorrectly report successful completion.

# Part 6 — Installation and Runtime Verification

## Definition of a Verification Step

A verification step is a specific check or test intended to determine whether a defined aspect of an SV caller Docker image is correctly configured or functioning as expected.

A verification script may contain several verification steps.

Use the existing three-part numbering convention where applicable:

`6.x.y`

where:

- `6` identifies Part 6 of the Installation Guide.
- `x` identifies the verification script or section.
- `y` identifies the individual verification step.

Each verification step must have identifiable prerequisites, expected results, pass/fail criteria, and diagnostic output.

## Individual Verification Scripts

Review all five verification scripts carefully.

Determine whether each existing verification step provides a meaningful and reliable check of its stated objective.

Correct tests that are incomplete, misleading, or prone to false positives or false negatives.

In particular:

- Image architecture checks must handle missing images and Docker inspection errors.
- Package version checks should compare actual installed versions against independently defined expected versions rather than merely exporting package inventories.
- Python dependency checks should verify the intended runtime environment and, where appropriate, successful imports.
- Executable checks should distinguish command discovery from successful execution.
- Command-line smoke tests should consider caller-specific CLI behavior, including commands that may return nonzero statuses when displaying help or usage information.
- Help-output logging and Conda inventory exports should be documented according to their actual purpose.
- A failed check should not prevent independent checks from being attempted.
- Each verification step must report its own outcome.

Preserve valid existing checks and specialized handling, especially the DeBreak dependency and `bsalign` checks, unless there is a specific technical reason to revise them.

Do not introduce redundant tests merely to increase the number of verification steps. Consolidate genuinely redundant operations only when doing so preserves meaningful coverage and clear reporting.

## Main Verification Script

Review and revise `s6_verify-main.sh`.

The main script must:

1. Execute the five verification scripts in their intended order.
2. Capture the individual verification results, not merely the final exit status of each script.
3. Report which verification steps passed, failed, or could not be executed.
4. Continue with independent verification steps despite failures elsewhere.
5. Record useful diagnostic information for troubleshooting.
6. Produce an overall summary that clearly identifies every failed or skipped verification step.
7. Return a nonzero exit status if any required verification step fails or cannot be completed.

## Error Handling and Result Reporting

Design a consistent reporting mechanism for both the building and verification workflows.

The mechanism should support:

- `PASS`: The step completed and met its defined success criteria.
- `FAIL`: The step was attempted but failed, or a required operation could not complete.
- `SKIP`: The step could not meaningfully execute because a prerequisite was unavailable or an earlier dependency failed.

A skipped required step must not be counted as a successful verification.

For scripts containing multiple steps, ensure that the main orchestration script can reliably identify the status of each step.

You may use a simple, consistent, machine-readable reporting convention, structured result files, or another robust Bash-compatible mechanism. Avoid relying solely on human-readable output and a single script-level exit code when multiple substeps must be reported.

Preserve useful standard output and standard error messages. Where appropriate, write diagnostic logs to predictable locations without losing the original command exit statuses.

The reporting mechanism should be consistent across scripts and understandable to someone maintaining the workflow later.

Do not implement unnecessary automatic recovery actions that conceal errors or materially alter the installed environments.

# Installation Guide Revisions

Review and update **Parts 5 and 6** of the Installation Guide so that they accurately describe the finalized building and verification scripts.

The updated sections must include:

1. The purpose of each building and verification script.
2. The correct execution order and current script filenames.
3. Instructions for independently executing individual scripts and running the main orchestration scripts.
4. The expected behavior and success/failure criteria of each major step.
5. Descriptions of generated logs, Conda inventories, and other result files.
6. Instructions for interpreting summaries, failures, and skipped steps.
7. Any prerequisites necessary to execute the scripts.
8. Appropriate explanations of the limitations of each verification method.

Ensure that the guide's examples, commands, step identifiers, and descriptions agree with the final scripts.

Some current step identifiers or script responsibilities may not correspond to the existing Installation Guide headings. Update the guide's structure and numbering where needed to establish consistency.

Section 6.6 (Functional Verification of DeBreak with Repo2's Simulated Dataset) of the existing Installation Guide contains a dataset-based DeBreak functional verification procedure.**This is outside the scope of this task.** Treat this as a future validation procedure, not as part of the current executable verification workflow. It may remain documented as a clearly deferred or optional step, but do not implement or execute dataset-based tests in this task, and do not modify, reproduce, or otherwise alter Section 6.6 in any way, except to re-number it if necessary to maintain sequential consistency with the revised Sections 6.1–6.5.

**Editing restriction:** Concentrate changes on Parts 5 and 6. Do not rewrite other sections unless a minimal change is essential to avoid an important inconsistency. If you identify inaccuracies elsewhere that do not require immediate correction, report them separately.

Preserve the guide's useful explanations and technical detail rather than unnecessarily shortening them.

# Validation Requirements

Before finalizing the revisions:

1. Check the Bash syntax of all revised scripts, using `bash -n` if execution facilities are available.
2. Confirm that the main scripts reference existing filenames and valid relative paths.
3. Review Bash error-handling behavior, including interactions involving `set -e`, `set -u`, `pipefail`, conditionals, loops, and command substitutions.
4. Review how individual results are captured and communicated to the orchestration scripts.
5. Review expected behavior for complete success, individual command failure, missing Docker images, missing prerequisites, and partial workflow failure.
6. Confirm that no failure can be mistakenly reported as success because of stale files, existing image tags, ignored exit statuses, or misleading output.
7. Ensure that the documentation accurately describes the final implementation.

Do not claim that Docker builds, container runtime tests, or remote-server operations were successfully executed unless you actually executed them and observed their results.

Clearly identify any checks requiring execution on my remote server.

# Required Deliverables

Please provide:

## 1. Initial Review Findings

Briefly describe the significant issues identified in the current scripts and Installation Guide, explaining the rationale for changes.

Distinguish actual defects from optional improvements.

## 2. Revised Building Scripts

Provide complete, executable versions of every building script that requires modification.

Preserve existing filenames wherever practical.

## 3. Revised Verification Scripts

Provide complete, executable versions of every verification script that requires modification.

Include any necessary changes to individual step numbering, result reporting, and orchestration.

## 4. Revised Installation Guide — Part 5 and Sections 6.1–6.5 Only

Provide complete, updated versions of **Part 5 (Building the Docker Images)** and **Sections 6.1–6.5 of Part 6 (Installation Verification)** of the Installation Guide.

- **Do not reproduce or rewrite the entire Installation Guide.** Output only the revised Part 5 and Sections 6.1–6.5, which I will manually incorporate into the existing Installation Guide.
- **Do not modify, reproduce, or remove Section 6.6 (Functional Verification of DeBreak with Repo2's Simulated Dataset).** Dataset-based functional validation is outside the scope of this request. I will retain the existing Section 6.6 unchanged.
- Preserve the existing structure, organization, technical explanations, and level of detail wherever they remain accurate and relevant.
- Ensure that the revised sections accurately and completely reflect the finalized building and verification scripts, including their commands, execution procedures, step numbering, expected results, error handling, and reporting.
- Include all necessary content within the revised Part 5 and Sections 6.1–6.5 so that they can directly replace the corresponding sections in the existing Installation Guide without requiring additional editing.
- Preserve the Markdown heading hierarchy and numbering conventions of the Installation Guide, including the existing Section 6.6 designation.
- If modifications to other parts of the Installation Guide are absolutely necessary for consistency, **do not rewrite those parts**. Instead, identify the specific location and provide the exact proposed changes separately, along with a brief explanation of why they are necessary.

Where file creation is supported, provide the revised Part 5 and Sections 6.1–6.5 as a separate downloadable Markdown file.

## 5. Change Summary

Summarize the important modifications to each affected file and explain why they were necessary.

Identify any scripts that required no changes.

## 6. Validation and Execution Instructions

Explain how I should deploy and execute the revised scripts on my remote server.

Include any commands necessary to make scripts executable, run the building and verification workflows, inspect their results, and determine whether additional image rebuilding is necessary.

Clearly distinguish checks completed during your review from checks I must execute myself.

Where file creation is supported, deliver revised scripts and the Installation Guide as separate downloadable files. Provide complete file contents rather than only patch fragments or pseudocode.

# Additional Instructions

- Prioritize technical accuracy, completeness, reliability, and maintainability over brevity.
- Avoid unnecessary changes to the existing structure.
- Do not modify Dockerfile recipes or Conda environment specifications unless a specific issue makes such a change necessary. If changes are warranted, explain them and identify the required rebuilding steps.
- Do not silently assume that existing tests have passed.
- Do not treat CLI startup or package metadata verification as proof of scientific correctness.
- Do not implement dataset-based SV calling tests at this stage.
- If an important requirement cannot be verified from the supplied materials, clearly state the limitation rather than inventing a result.
- Make reasonable, explicitly documented implementation decisions when the existing structure permits more than one valid approach.