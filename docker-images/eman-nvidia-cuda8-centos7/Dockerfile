FROM nvidia/cuda:8.0-devel-centos7

# Set an encoding to make things work smoothly.
ENV LANG en_US.UTF-8
ENV PYTHONUNBUFFERED 1

RUN yum groupinstall "Development tools" -y && \
    yum install -y \
               devtoolset-4 \
               gcc \
               gcc-c++ \
               bzip2 \
               mesa-libGLU-devel \
               libXext-devel \
               libXrender-devel \
               libSM-devel \
               libX11-devel \
               fontconfig && \
    yum clean all && \
    useradd -m eman
USER eman
WORKDIR /home/eman
ENV PATH /home/eman/miniconda2/bin:$PATH
RUN curl -v -L https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -o miniconda.sh && \
    bash miniconda.sh -b && \
    source activate root && \
    conda config --set show_channel_urls true && \
    conda install conda-build --yes && \
    curl -v -L -O https://github.com/cryoem/eman2/archive/v2.2.tar.gz && \
    tar xzvf v2.2.tar.gz
RUN conda build eman2-2.2/recipes/eman/ -c cryoem -c defaults -c conda-forge --numpy 1.8
RUN conda install libgfortran=1.0 && \
    conda install eman2 --use-local -c cryoem -c defaults -c conda-forge
RUN conda build purge-all &&\
    conda clean -a

CMD [ "/bin/bash" ]
