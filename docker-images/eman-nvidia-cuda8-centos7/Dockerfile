FROM nvidia/cuda:8.0-devel-centos7

# Set an encoding to make things work smoothly.
ENV LANG en_US.UTF-8

WORKDIR /workspace
COPY docker-images/eman-nvidia-cuda8-centos7/yum.sh /workspace/
RUN bash /workspace/yum.sh
RUN curl -v -L https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -o miniconda.sh
RUN pwd && ls
RUN bash miniconda.sh -bf
RUN source /root/miniconda2/bin/activate root
RUN conda config --set show_channel_urls true
RUN conda install conda-build --yes
RUN curl -v -L -O https://github.com/cryoem/eman2/archive/v2.2.tar.gz
RUN tar xzvf eman2-2.2.tar.gz
RUN conda build eman2-2.2/recipes/eman -c cryoem -c defaults -c conda-forge
RUN conda install eman2 --use-local
RUN conda build purge-all


ENV PATH /root/miniconda2/bin:$PATH
ENV PYTHONUNBUFFERED 1

CMD [ "/bin/bash" ]
