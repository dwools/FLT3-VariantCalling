#!/bin/bash
# 5.2. Confirm all 10 SV caller Docker images were built successfully.

# If any are missing, print which ones are missing and exit with an error.
expected_images=(
  "sv-callers:cutesv-2.1.4"
  "sv-callers:debreak-1.3"
  "sv-callers:delly-2.7.0"
  "sv-callers:dysgu-1.9.0"
  "sv-callers:nanomonsv-0.9.0"
  "sv-callers:nanovar-1.8.3"
  "sv-callers:savana-1.3.8"
  "sv-callers:severus-1.7"
  "sv-callers:sniffles2-2.8.1"
  "sv-callers:svim-2.0.0"
)

images=$(docker image ls --filter 'reference=sv-callers:*' --format '{{.Repository}}:{{.Tag}}')

missing_images=()

for img in "${expected_images[@]}"; do
  if ! grep -Fxq "$img" <<< "$images"; then
    missing_images+=("$img")
  fi
done

if [ "${#missing_images[@]}" -ne 0 ]; then
  echo "Error: The following expected Docker images were not found:" >&2
  printf '%s\n' "${missing_images[@]}" >&2
  exit 1
fi

echo "All build commands exited successfully. Verify runtime independently."

