# Copyright (c) 2025 Hiroyuki Okada
# All rights reserved.
FROM ubuntu:20.04 AS cpu
LABEL maintainer="Hiroyuki Okada <hiroyuki.okada@okadanet.org>"
LABEL org.okadanet.vendor="Hiroyuki Okada" \
      org.okadanet.dept="TIDBots" \
      org.okadanet.version="1.0.0" \
      org.okadanet.released="November 1, 2025"

RUN sed -i.org -e 's|archive.ubuntu.com|ubuntutym.u-toyama.ac.jp|g' /etc/apt/sources.list
RUN apt-get clean
RUN /bin/echo -e "Acquire::http::Timeout \"300\";\n\
   Acquire::ftp::Timeout \"300\";" >> /etc/apt/apt.conf.d/timeout_setting

# Install packages without prompting the user to answer any questions
ENV DEBIAN_FRONTEND noninteractive 
RUN apt-get update && apt-get install -y \
locales language-pack-ja-base language-pack-ja locales fonts-takao \
sudo lsb-release ca-certificates wget curl git subversion libssl-dev \
nano vim htop \
dbus-x11 mesa-utils x11-utils x11-apps \
terminator xterm \
build-essential software-properties-common gdb valgrind && \
apt-get clean && rm -rf /var/lib/apt/lists/*

# Install tmux 3.2
RUN apt-get update && apt-get install -y automake autoconf pkg-config libevent-dev libncurses5-dev bison && \
apt-get clean && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/tmux/tmux.git && \
cd tmux && git checkout tags/3.2 && ls -la && sh autogen.sh && ./configure && make -j8 && make install

# Set locale
RUN  locale-gen ja_JP ja_JP.UTF-8  \
  && update-locale LC_ALL=ja_JP.UTF-8 LANG=ja_JP.UTF-8 \
  && add-apt-repository universe
# Locale
ENV LANG ja_JP.UTF-8
ENV TZ=Asia/Tokyo

RUN apt-get update && apt-get install -y \
  build-essential cmake g++ \
  iproute2 gnupg gnupg1 gnupg2 \
  libcanberra-gtk* \
  python3-pip  python3-tk \
  git wget curl \
  alsa-utils pulseaudio \
  x11-utils x11-apps terminator xterm xauth mesa-utils\
  terminator xterm nano vim htop \
  software-properties-common gdb valgrind sudo

# Install ROS Noetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update \
 && apt-get install -y --no-install-recommends ros-noetic-desktop-full
RUN apt-get install -y --no-install-recommends python3-rosdep python3-catkin-tools
RUN apt-get install -y --no-install-recommends  ros-noetic-audio-common
RUN rosdep init \
 && rosdep fix-permissions \
 && rosdep update






# Add user and group
ARG UID
ARG GID
ARG USER_NAME
ARG GROUP_NAME
ARG PASSWORD
RUN groupadd -g $GID $GROUP_NAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USER_NAME && \
    echo $USER_NAME:$PASSWORD | chpasswd && \
    echo "$USER_NAME   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER ${USER_NAME}

# Config (if you wish)
RUN mkdir -p ~/.config/terminator/
COPY assets/terminator_config /home/$USER_NAME/.config/terminator/config 
COPY assets/tmux.conf /home/$USER_NAME/.tmux.conf
COPY assets/tmux.session.conf /home/$USER_NAME/.tmux.session.conf 

# .bashrc
RUN echo "source /opt/ros/noetic/setup.bash" >> /home/${USER_NAME}/.bashrc
#RUN echo "source /home/${USER_NAME}/Dropbox/workspace/catkin_ws/devel/setup.bash" >> /home/$USER_NAME/.bashrc


# entrypoint
COPY ./assets/entrypoint.sh /
RUN sudo chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /home/$USER_NAME
CMD ["/bin/bash"]


#FROM nvidia/cuda:12.9.1-cudnn-devel-ubuntu20.04 AS gpu
#FROM nvidia/cuda:13.0.1-cudnn-devel-ubuntu22.04 AS gpu
FROM nvidia/cudagl:11.3.0-devel-ubuntu20.04 AS gpu

# Install packages without prompting the user to answer any questions
ENV DEBIAN_FRONTEND noninteractive 
RUN apt-get update && apt-get install -y \
locales language-pack-ja-base language-pack-ja locales fonts-takao \
sudo lsb-release ca-certificates wget curl git subversion libssl-dev \
nano vim htop \
dbus-x11 mesa-utils x11-utils x11-apps \
terminator xterm \
build-essential software-properties-common gdb valgrind && \
apt-get clean && rm -rf /var/lib/apt/lists/*

# Install tmux 3.2
RUN apt-get update && apt-get install -y automake autoconf pkg-config libevent-dev libncurses5-dev bison && \
apt-get clean && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/tmux/tmux.git && \
cd tmux && git checkout tags/3.2 && ls -la && sh autogen.sh && ./configure && make -j8 && make install

# Set locale
RUN  locale-gen ja_JP ja_JP.UTF-8  \
  && update-locale LC_ALL=ja_JP.UTF-8 LANG=ja_JP.UTF-8 \
  && add-apt-repository universe
# Locale
ENV LANG ja_JP.UTF-8
ENV TZ=Asia/Tokyo

RUN apt-get update && apt-get install -y \
  build-essential cmake g++ \
  iproute2 gnupg gnupg1 gnupg2 \
  libcanberra-gtk* \
  python3-pip  python3-tk \
  git wget curl \
  x11-utils x11-apps terminator xterm xauth mesa-utils\
  alsa-utils pulseaudio \
  terminator xterm nano vim htop \
  software-properties-common gdb valgrind sudo

# Install ROS Noetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update \
 && apt-get install -y --no-install-recommends ros-noetic-desktop-full
RUN apt-get install -y --no-install-recommends python3-rosdep
RUN rosdep init \
 && rosdep fix-permissions \
 && rosdep update



# Add user and group
ARG UID
ARG GID
ARG USER_NAME
ARG GROUP_NAME
ARG PASSWORD
RUN groupadd -g $GID $GROUP_NAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USER_NAME && \
    echo $USER_NAME:$PASSWORD | chpasswd && \
    echo "$USER_NAME   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER ${USER_NAME}

# Config (if you wish)
RUN mkdir -p ~/.config/terminator/
COPY assets/terminator_config /home/$USER_NAME/.config/terminator/config 
COPY assets/tmux.conf /home/$USER_NAME/.tmux.conf
COPY assets/tmux.session.conf /home/$USER_NAME/.tmux.session.conf 

# .bashrc
RUN echo "source /opt/ros/noetic/setup.bash" >> /home/${USER_NAME}/.bashrc
#RUN echo "source /home/${USER_NAME}/Dropbox/workspace/catkin_ws/devel/setup.bash" >> /home/$USER_NAME/.bashrc


# entrypoint
COPY ./assets/entrypoint.sh /
RUN sudo chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["/bin/bash"]
WORKDIR /home/$USER_NAME

