FROM ubuntu:focal
ARG WORKSPACE


# install packages & setup locales
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-utils \
    bash-completion \
    build-essential \
    ca-certificates \
    curl \
    dirmngr \
    gdb \
    git \
    gnupg2 \
    keyboard-configuration \
    locales \
    lsb-release \
    python3-pip \
    software-properties-common \
    udev \
    wget \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US en_US.UTF-8; dpkg-reconfigure -f noninteractive locales

ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"


# install ROS2 & init rosdep
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - \
    && echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ros-noetic-ros-base \
    ros-noetic-rviz \
    ros-noetic-cv-bridge \
    python3-autopep8 \
    python3-rosdep \
    python3-vcstool \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && /bin/bash -c 'source /opt/ros/humble/setup.bash; rosdep init'
    
 

# install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3-catkin-tools \
    python3-osrf-pycommon


#create workspace
RUN mkdir -p /catkin_ws/src

RUN cd /catkin_ws/src && git clone https://github.com/ethz-asl/kindr

RUN cd /catkin_ws/src && git clone https://github.com/Michal-Bidzinski/rovio.git

RUN cd /catkin_ws/src/rovio && git submodule update --init --recursive


RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd /catkin_ws; catkin build rovio --cmake-args -DCMAKE_BUILD_TYPE=Release'


RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
RUN echo "source /catkin_ws/devel/setup.bash" >> ~/.bashrc
