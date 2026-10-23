#!/bin/bash
set -euo pipefail # This ensures the script exits on errors, undefined variables, and pipe failures

# cd /mnt/pikachu/dwools/flt3/nanopore_FLT3_20240621_Flt3_amplicon_B/variants/variant_calling_scripts/FLT3ITD_IsolationScripts/VariantCallerContainerInstallationScripts/sv-callers-docker

echo "Building Docker images...
"

# Build sniffles2 Docker image
echo "
Building sniffles2 Docker image...
"
docker build --platform linux/amd64 --progress=plain \
  -t sv-callers:sniffles2-2.8.1 ./sniffles2

echo "
Finished building sniffles2 Docker image!
"

# Confirm sniffles2 Docker image was built successfully
echo "
Confirming Docker image for sniffles2 was built successfully...(you should see entries for the successfully built image)
"

images=$(docker image ls --filter 'reference=sv-callers:*' --format '{{.Repository}}:{{.Tag}}')

printf '%s\n' "$images"

if ! grep -Fxq 'sv-callers:sniffles2-2.8.1' <<< "$images"; then
  echo "Error: expected Docker image sv-callers:sniffles2-2.8.1 was not found." >&2
  exit 1
fi

echo "
Docker image for sniffles2 built successfully!
"

# Check sniffles2 Docker image architecture
echo "
Checking sniffles2 Docker image architecture...(expeted output: 'linux/amd64')
"
docker image inspect sv-callers:sniffles2-2.8.1 \
  --format '{{.Os}}/{{.Architecture}}'

echo "
Finished checking sniffles2 Docker image architecture!
"

