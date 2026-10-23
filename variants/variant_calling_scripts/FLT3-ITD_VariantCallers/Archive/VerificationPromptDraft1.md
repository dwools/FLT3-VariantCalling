# Prompt draft for querying LLM for help performing verification steps on all SV callers

You are an expert in LLM prompt engineering. Please review my draft LLM prompt below. Then tell me if it should be revised for optimal comprehension and effectiveness by the LLM, and if so, how. The LLM to be used is GPT-6. You will require expertise in Conda, Docker, and sequencing bioinformatics to understand the draft prompt. I have attached all resources and scripts referenced in the draft prompt for your reference. Here is the draft prompt, enclosed in triple quotes:


"""
## Role and Expertise
You are an expert bioinformatician specializing in long-read sequencing, structural variant detection, Linux systems administration, Conda package management, and Docker containerization.

## Request
I would like your assistance reviewing and finalizing the scripts that represent the complete building and verification processes for the newly built SV caller Docker images. The goals are to ensure each caller is correctly installed, configured, and able to process datasets as expected in its Docker image, in addition to being well organized, annotated, and easily understandable, and that the documentation, including the Installation Guide, accurately reflects the final procedures.

## Related resources
I have attached the Installation Guide and all scripts associated with building the SV caller Docker images and verifying their functionality. The scripts are based on the Installation Guide you provided in another chat "titled "Installing SV Callers" for constructing, building, and verifying the ten SV caller Docker images (though the scripts have been since been updated from the original Installation Guide's code blocks). The Installation Guide is attached here as <SV_Caller_Docker_Installation_Guide_REVISED.sh>.

Building the SV caller Docker images is covered in Section 5 of the Installation Guide. All of the building scripts' filenames begin with "s5" (since they're associated with Section 5 of the Installation Guide).

Verification of the Docker images' functionality is covered in Section 6 of the Installation Guide. All of the verification scripts' filenames begin with "s6" (since they're associated with Section 6 of the Installation Guide). The recipes used to build each image are as written in Section 4 of the Installation Guide.

## Attachments
<SV_Caller_Docker_Installation_Guide_REVISED.sh>
<s5_build-main.sh>
<s5-1_BuildVariantCallerDockerImages.sh>
<s5-2_ConfirmDockerImageCreation.sh>
<s6_verify-main.sh>
<s6-1_ConfirmImageArchitecture.sh>
<s6-2_VerifyImageCommandLineFunctioning.sh>
<s6-3_VerifyDeBreakPackageVersionsAndPythonDependencies.sh>
<s6-4_VerifyDeBreakBundledBsalineAndOtherExecutables.sh>
<s6-5_VerifyCondaPackageManifestsAndHelpOutputs.sh>

## Action items
- Carefully read through all attached materials.
- Update the Installation Guide so that it accurately and completely reflects the building and verification process, ensuring correctness and completeness.
- Ensure that all steps are properly documented.
- Update the Installation Guide to reflect any changes made to the verification scripts and ensure that all instructions are accurate, complete, and consistent with the final verification steps.
- Update the main building script (s5_build-main.sh) and main verification script (s6_verify-main.sh) to ensure proper orchestration, error handling, and reporting of individual building and verification steps.
- Revise Section 5.1 (Build Each Image) so that it does not exit immediately upon encountering a build failure, but instead attempts to build all images and reports which ones failed and which ones succeeded.
- Only focus on updating Section 6 and Section 5 of the Installation Guide. Do not make changes to other sections unless absolutely necessary for consistency with the updates in Sections 5 and 6.



## Supporting information

- All SV caller Docker images have been built and are available for verification, but I am open to re-building any images if necessary if any revisions are made to the building steps.

### Building
- A "building step" is defined as a specific action or command within the installation process related to the building of a Docker image. A building step also covers confirmation of the successful execution of the build command. It includes the input conditions, the expected outcome, and the criteria for determining success or failure.

- Each building script should consist of a single building step, such that each step is self-contained and accounts for its own input conditions, expected output, and criteria for determining success or failure, and independently executable.

- All building scripts should be executed from a main building script that orchestrates the execution of each individual building script in sequence. The main building script is also responsible for:
    - Capturing and reporting the results of each building step.
    - Providing a summary of the overall build results.
    - Handling any errors encountered during the execution of individual building scripts and providing appropriate error messages to facilitate troubleshooting. Errors that occur during the execution of a building step should be passed to the main building script for proper handling and reporting. If building scripts need to be updated to facilitate this error handling, they should be revised accordingly.
    - Ensuring that the overall build process continues smoothly even if individual steps encounter errors, by appropriately managing and recovering from such errors.
    - Providing clear and actionable feedback to the user, indicating which steps succeeded, which steps failed, and any necessary actions to resolve encountered issues.

### Verification
- A "verification step" is defined as a specific check or test within a verification script that confirms whether a particular aspect of the system or process is functioning correctly.

- A verification script may be composed of multiple verification steps, each addressing a specific aspect of the system or process being verified. In such cases, a verification step is denoted by a three-part numberal '6.x.y.' (i.e., "verifcation step 'y' of verification script 'x' of Installation Guide Part 6 (Verification section)"). A verification step should be self-contained and account for its own input conditions, expected output, and the criteria for determining the step's success or failure.

- All verification scripts should be executed from a main verification script that orchestrates the execution of each individual script in sequence. The main verification script is also responsible for the following:
    - Capturing and reporting the results of each verification step.
    - Providing a summary of the overall verification results, indicating which verification steps passed or failed, and highlighting any issues that need attention.
    - Handling any errors encountered during the execution of individual verification scripts and providing appropriate error messages to facilitate troubleshooting. Errors that occur during the execution of a verification step should be passed to the main verification script for proper handling and reporting. If verifification scripts need to be updated to facilitate this error handling, they should be revised accordingly.
    - Ensuring that the overall verification process continues smoothly even if individual steps encounter errors, by appropriately managing and recovering from such errors.
    - Providing clear and actionable feedback to the user, indicating which verification steps succeeded, which steps failed, and any necessary actions to resolve encountered issues.

- The Installation Guide should be revised to accurately reflect the most current state of the scripts, rather than the scripts being revised to match the Installation Guide.

- Some of the step's indices in the scripts may not correspond directly to the sections in the Installation Guide. In such instances, the Installation Guide should be revised to match the script's structure and labeling.

- Some of the scripts may have new or revised code that is not yet reflected in the Installation Guide. In such cases, the Installation Guide should be updated to accurately represent the current state of the scripts and their functionality.

- This request does not yet concern testing the SV caller functionality on a specific dataset or sample. I will ask for assistance with that separately when needed.

- Prioritize completeness and technical accuracy over brevity.

"""

