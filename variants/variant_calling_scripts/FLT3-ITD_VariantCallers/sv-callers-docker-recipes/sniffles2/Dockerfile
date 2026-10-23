FROM condaforge/miniforge3:26.7.2-0

COPY environment.yml /tmp/environment.yml
RUN conda config --system --set channel_priority strict \
    && conda env create --file /tmp/environment.yml \
    && conda clean --all -y \
    && rm /tmp/environment.yml

ENV PATH="/opt/conda/envs/sv/bin:${PATH}"
WORKDIR /work
ENTRYPOINT ["sniffles"]
