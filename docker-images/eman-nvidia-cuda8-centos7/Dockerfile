FROM nvidia/cuda:8.0-devel-centos7

# Set an encoding to make things work smoothly.
ENV LANG en_US.UTF-8

WORKDIR /workspace
COPY docker-images/eman-nvidia-cuda8-centos7/yum.sh /workspace/
RUN bash /workspace/yum.sh
RUN curl -v -L https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -o miniconda.sh
RUN pwd && ls && ls /root
RUN bash miniconda.sh -bf -p /workspace

ENV PATH /root/miniconda2/bin:$PATH
ENV PYTHONUNBUFFERED 1

CMD [ "/bin/bash" ]
