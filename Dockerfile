FROM nvidia/cuda:8.0-cudnn5-devel
ENV DEBIAN_FRONTEND noninteractive
# start with the nvidia container for cuda 8 with cudnn 5

# forked from https://github.com/mjsobrep/DockerFiles-public
# then forked from https://hub.docker.com/r/garyfeng/docker-openpose/~/dockerfile/
LABEL maintainer "Frederico B. Klein <frederico.klein@plymouth.ac.uk>"

RUN apt-get update -y && apt-get install -y --no-install-recommends \
      apt-utils \
      wget \
      unzip \
      lsof \
      lsb-core \
      git \
      libatlas-base-dev \
      libopencv-dev \
      python-opencv \
      python-pip \
      python-setuptools \
      openssh-server\
      libssl-dev \
      #python-sh is needed for the fix.py. once that is solved, remove it.
      python-sh \
      tar\
      && rm -rf /var/lib/apt/lists/*

# to get ssh working for the ros machine to be functional: (adapted from docker docs running_ssh_service)
RUN mkdir /var/run/sshd \
    && echo 'root:ros_ros' | chpasswd \
    && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile" \
    && echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

ENV PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
RUN pip install --upgrade pip

#ENV RDI=openpose-master
ENV RDI=openpose-1.2.1
ENV OPENPOSE_VERSION=1.2.1
ENV OPENCV_VERSION=2.4.13

RUN wget https://github.com/CMU-Perceptual-Computing-Lab/openpose/archive/v${OPENPOSE_VERSION}.zip; \
    unzip v${OPENPOSE_VERSION}.zip; rm v${OPENPOSE_VERSION}.zip

WORKDIR $RDI

RUN sed -i 's/\<sudo chmod +x $1\>//g' ubuntu/install_caffe_and_openpose_if_cuda8.sh; \
    sed -i 's/\<sudo chmod +x $1\>//g' ubuntu/install_openpose_if_cuda8.sh; \
    sed -i 's/\<sudo -H\>//g' 3rdparty/caffe/install_caffe_if_cuda8.sh; \
    sed -i 's/\<sudo\>//g' 3rdparty/caffe/install_caffe_if_cuda8.sh; \
    sync; sleep 1; ./ubuntu/install_caffe_and_openpose_if_cuda8.sh

ADD scripts/ros.sh /$RDI/
#RUN pip install --upgrade catkin_pkg_modules ### had some problems with terminal_color

RUN ./ros.sh
RUN echo "source /root/ros_catkin_ws/install_isolated/setup.bash" >> /etc/bash.bashrc

#ADD scripts/catkin_ws.sh /$RDI/
#RUN ./catkin_ws.sh $RDI

#add my snazzy banner
ADD banner.txt /$RDI/

ADD scripts/entrypoint.sh /$RDI/
ENTRYPOINT ["/openpose-1.2.1/entrypoint.sh","/openpose-1.2.1/"]
