#!/usr/bin/env bash

yum install -y \
               gcc gcc-c++ \
               mesa-libGLU-devel \
               libXext-devel \
               libXrender-devel \
               libSM-devel \
               libX11-devel && \
yum clean all
