# Structural variant caller Docker recipes (revised research draft, 2026-10-21)

Each caller directory has a Dockerfile and environment.yml.

## Compatibility target

- Linux/amd64, conda linux-64.
- `condaforge/miniforge3:26.7.2-0` base, configured strict channel priority.
- Channels: conda-forge > bioconda; defaults excluded.
- Caller environments installed at `/opt/conda/envs/sv`.
- Docker images have individual entrypoints.

## Build

On a host with Docker and internet access:

```bash
chmod +x build-all.sh verify-all.sh
./build-all.sh
./verify-all.sh
```

Inspect `verification/*-help.log` carefully; CLI help exit codes can differ by caller.

## Warning

The files are proposed recipes and were not built/tested in this environment.
The older DeBreak stack may fail Conda solving under current channels.
DeBreak v1.3 is installed from Bioconda, which fetches ChongLab/DeBreak v1.3 and bundles bsalign. No source compilation is needed. Verify the packaged executable on your host CPU and runtime environment.
The DeBreak Python=3.10 pin is provisional; troubleshoot any Conda solver errors.
The `debreak --version` CLI text is stale upstream; verify via `conda list --name sv debreak`.
The Conda NanoVar TensorFlow/NumPy combo requires runtime verification.
Do not consider successful `conda env create` alone a biological correctness test.

## Additional provenance

Review upstream docs and Bioconda recipes for each caller. After validation,
archive image digest and explicit Conda manifests for exact reruns.

NanoVar explicitly uses the verified available conda-forge TensorFlow CPU 2.15.0; upstream suggests pip 2.15.1, while Bioconda permits <=2.15.1.
