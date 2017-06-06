FROM centos:6

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
               fontconfig \
               xorg-x11-fonts-Type1 \
               sudo && \
    yum clean all && \
    fc-cache -f -v
RUN useradd -m eman -G wheel && \
    echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    echo 'Defaults:%wheel !requiretty' >> /etc/sudoers
USER eman
WORKDIR /home/eman
ENV PATH /home/eman/miniconda2/bin:$PATH
RUN curl -v -L https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -o miniconda.sh && \
    bash miniconda.sh -b && \
    rm miniconda.sh && \
    source activate root && \
    conda config --set show_channel_urls true && \
    conda install conda-build --yes && \
    conda install libgfortran=1.0 --yes && \
    conda clean --all --yes
RUN curl -v -L -O https://github.com/cryoem/eman2/archive/v2.2.tar.gz && \
    tar xzvf v2.2.tar.gz && \
    conda build eman2-2.2/recipes/eman/ -c cryoem -c defaults -c conda-forge --numpy 1.8 --no-test && \
    conda install eman2 --use-local -c cryoem -c defaults -c conda-forge && \
    conda build purge-all &&\
    conda clean --all --yes

CMD [ "/bin/bash" ]
