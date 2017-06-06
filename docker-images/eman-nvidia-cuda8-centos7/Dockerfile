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
RUN curl -v -L https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -o miniconda.sh

CMD [ "/bin/bash" ]
