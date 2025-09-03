From ubuntu:20.04

# These argumets can be overwrited by "--build-arg".
ARG DEBIAN_FRONTEND=noninteractive
ARG usern=jack
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid $USER_GID $usern
RUN useradd --uid $USER_UID --gid $USER_GID -m $usern
RUN apt-get update && apt-get install --no-install-recommends -y \
    lsb-release \
    sudo \
    bash-completion \
    git \
    software-properties-common

# language setting
RUN apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get install debconf -y
RUN apt-get install keyboard-configuration -y
RUN dpkg-reconfigure keyboard-configuration

# tools
RUN apt-get install vim tmux -y

RUN echo "$usern ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$usern
RUN chmod 0440 /etc/sudoers.d/$usern
RUN chown -R $usern:$usern /home/$usern
ENV USER=$usern
ENV HOME=/home/$usern
USER $usern
WORKDIR $HOME
RUN ln -sf ~/share/.bash_history ~/.bash_history
