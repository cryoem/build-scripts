FROM centos:7

# Set an encoding to make things work smoothly.
ENV LANG en_US.UTF-8
ENV PYTHONUNBUFFERED 1

RUN yum install -y \
               gcc \
               gcc-c++ \
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

CMD [ "/bin/bash" ]
