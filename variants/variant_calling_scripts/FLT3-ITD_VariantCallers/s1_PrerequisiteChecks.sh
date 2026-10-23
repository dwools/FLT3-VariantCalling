#!/bin/bash
set -euo pipefail # This ensures the script exits on errors, undefined variables, and pipe failures

echo "Checking system prerequisites...
"
echo "PART 1.1: Ubuntu System Information and Docker Test
"
echo "Expected results include:
    <VERSION_ID="22.04"> for Ubuntu.
    <x86_64> from <uname -m>.
    <amd64> from <dpkg --print-architecture>.
"
echo "COMMAND: cat /etc/os-release:"
cat /etc/os-release
echo ""
echo "COMMAND: uname -m:"
uname -m
echo ""
echo "COMMAND: dpkg --print-architecture:"
dpkg --print-architecture
echo ""


echo "
PART 1.2: Verify Docker
"
echo "The <docker run --rm hello-world> command downloads and executes Docker's official test container. A successful result includes the message <Hello from Docker!>. If Docker reports a daemon connection error, inspect the service: <sudo systemctl status docker>. If service is stopped, start it with <sudo systemctl start docker>.
"
echo "COMMAND: docker --version:"
docker --version
echo ""
echo "COMMAND: docker info:"
docker info
echo ""
echo "COMMAND: docker run --rm hello-world:"
docker run --rm hello-world
echo ""

echo "
PART 1.3: Verify Docker permissions
"
echo "If docker ps returns a permission-denied error for /var/run/docker.sock, the user may lack access to the Docker daemon.

On a server where you have administrative permission to change group membership:

sudo usermod -aG docker "$USER"
Log out and reconnect through SSH before checking again.

Security note: Docker group membership effectively grants root-level privileges on the host. On a managed research server, follow the administrator's Docker access policy rather than changing group membership yourself.
"
echo "COMMAND: id:"
id
echo ""
echo "COMMAND: groups:"
groups
echo ""
echo "COMMAND: docker ps:"
docker ps
echo ""


echo "
PART 1.4: Check available resources
"
echo "These commands display available CPU threads, memory, filesystem space, and Docker disk usage.

The images will vary considerably in size. NanoVar, in particular, can require substantial storage because of TensorFlow.
"
echo "COMMAND: nproc:"
nproc
echo ""
echo "COMMAND: free -h:"
free -h
echo ""
echo "COMMAND: df -h:"
df -h
echo ""
echo "COMMAND: docker system df:"
docker system df
echo ""


echo "
PART 1.5: Verify connectivity to image and package repositories
"
echo "This verifies that Docker can retrieve the selected base image. It does not by itself verify access to Conda-forge, Bioconda, or GitHub. Actual environment creation in Part 5 tests Conda repository access.

The Miniforge Docker image is maintained by the Conda-forge project and contains Conda installed at /opt/conda. Its Docker Hub listing identifies 26.7.2-0 as a versioned tag with an AMD64 image.

No Conda installation is required on the Ubuntu host. When you reach the optional DeBreak functional test in Part 6, the host will need git; transferring/extracting the project archive also requires scp (on your local computer) and unzip (on the host). Check availability with:

# Ubuntu host: needed only for the relevant steps
command -v git
command -v unzip
If missing, ask the server administrator to install these utilities, or obtain and transfer the test files using an administrator-approved method. No host-level Python, Conda, compiler, or bsalign installation is required.
"
echo "COMMAND: docker pull --platform linux/amd64 condaforge/miniforge3:26.7.2-0"
docker pull --platform linux/amd64 condaforge/miniforge3:26.7.2-0
echo ""

echo "FINISHED"