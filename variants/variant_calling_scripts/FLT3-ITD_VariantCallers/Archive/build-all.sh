#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
echo "== Building cutesv 2.1.4 =="
docker build --platform linux/amd64 --progress=plain --tag sv-callers:cutesv-2.1.4 ./cutesv
echo "== Building debreak 1.3 =="
docker build --platform linux/amd64 --progress=plain --tag sv-callers:debreak-1.3 ./debreak
echo "== Building delly 2.7.0 =="
docker build --platform linux/amd64 --progress=plain --tag sv-callers:delly-2.7.0 ./delly
echo "== Building dysgu 1.9.0 =="
docker build --platform linux/amd64 --progress=plain --tag sv-callers:dysgu-1.9.0 ./dysgu
echo "== Building nanomonsv 0.9.0 =="
docker build --platform linux/amd64 --progress=plain --tag sv-callers:nanomonsv-0.9.0 ./nanomonsv
echo "== Building nanovar 1.8.3 =="
docker build --platform linux/amd64 --progress=plain --tag sv-callers:nanovar-1.8.3 ./nanovar
echo "== Building savana 1.3.8 =="
docker build --platform linux/amd64 --progress=plain --tag sv-callers:savana-1.3.8 ./savana
echo "== Building severus 1.7 =="
docker build --platform linux/amd64 --progress=plain --tag sv-callers:severus-1.7 ./severus
echo "== Building sniffles2 2.8.1 =="
docker build --platform linux/amd64 --progress=plain --tag sv-callers:sniffles2-2.8.1 ./sniffles2
echo "== Building svim 2.0.0 =="
docker build --platform linux/amd64 --progress=plain --tag sv-callers:svim-2.0.0 ./svim
echo "All build commands exited successfully. Verify runtime independently."
docker image ls --filter reference='sv-callers:*'
