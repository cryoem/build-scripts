FROM nvidia/cuda:8.0-devel-centos7

# Set an encoding to make things work smoothly.
ENV LANG en_US.UTF-8

RUN yum install -y \
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
    yum clean all
RUN curl -v -L https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -o miniconda.sh
RUN pwd && ls && ls /root && whoami
RUN bash miniconda.sh -b && \
    source /root/miniconda2/bin/activate root && \
    conda config --set show_channel_urls true && \
    conda install conda-build --yes && \
    curl -v -L -O https://github.com/cryoem/eman2/archive/v2.2.tar.gz && \
    tar xzvf v2.2.tar.gz

ENV PATH /root/miniconda2/bin:$PATH
ENV PYTHONUNBUFFERED 1

CMD [ "/bin/bash" ]
