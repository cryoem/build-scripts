FROM centos:6


# Set an encoding to make things work smoothly.
ENV LANG en_US.UTF-8

# Resolves a nasty NOKEY warning that appears when using yum.
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

# Install basic requirements.
RUN bash yum.sh

RUN bash ../scripts/conda_environment.sh centos6

ENV PATH /root/miniconda2/bin:$PATH
ENV PYTHONUNBUFFERED 1

CMD [ "/bin/bash" ]
