#!/usr/bin/env bash
#from http://wiki.ros.org/kinetic/Installation/Source with minor adaptations to make it compile

pip install -U --upgrade rosdep rosinstall_generator wstool rosinstall rosdistro
rosdep init
rosdep update

ROS_DISTRO=kinetic
#ROS_DISTRO=melodic

#add-apt-repository ppa:ondrej/apache2

echo "deb http://ppa.launchpad.net/ondrej/apache2/ubuntu xenial main " >>  /etc/apt/sources.list

echo "deb-src http://ppa.launchpad.net/ondrej/apache2/ubuntu xenial main " >>  /etc/apt/sources.list

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 14AA40EC0831756756D7F66C4F4EA0AAE5267A6C

apt-get update

mkdir ~/ros_catkin_ws
cd ~/ros_catkin_ws

rosinstall_generator ros_comm sensor_msgs image_transport common_msgs --rosdistro ${ROS_DISTRO} --deps --wet-only --tar > ${ROS_DISTRO}-ros_comm-wet.rosinstall

wstool init -j8 src ${ROS_DISTRO}-ros_comm-wet.rosinstall

rosdep install --from-paths src --ignore-src --rosdistro ${ROS_DISTRO} -y

./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release

