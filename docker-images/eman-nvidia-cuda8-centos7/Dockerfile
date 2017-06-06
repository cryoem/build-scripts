FROM nvidia/cuda:8.0-devel-centos7

# Set an encoding to make things work smoothly.
ENV LANG en_US.UTF-8

WORKDIR /workspace
COPY docker-images/eman-nvidia-cuda8-centos7/yum.sh set_conda_environment.sh /workspace/
RUN bash /workspace/yum.sh
RUN curl -v -L -O https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh && \
    bash Miniconda2-latest-Linux-x86_64.sh -b && \
    source ${HOME}/miniconda2/bin/activate root && \
    conda config --set show_channel_urls true && \
    conda install conda-build --yes && \
    curl -v -L -O https://github.com/cryoem/eman2/archive/v2.2.tar.gz && \
    tar xzvf eman2-2.2.tar.gz && \
    conda build eman2-2.2/recipes/eman -c cryoem -c defaults -c conda-forge && \
    conda install eman2 --use-local && \
    conda build purge-all


ENV PATH /root/miniconda2/bin:$PATH
ENV PYTHONUNBUFFERED 1

CMD [ "/bin/bash" ]
