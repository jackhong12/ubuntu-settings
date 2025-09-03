From ubuntu-20-lite

# These argumets can be overwrited by "--build-arg".
ARG DEBIAN_FRONTEND=noninteractive
ARG usern=jack
ARG USER_UID=1000
ARG USER_GID=1000

SHELL ["/bin/bash", "-c"]

# Install ubuntu-settings
COPY ./ $HOME/ubuntu-settings

RUN pushd $HOME/ubuntu-settings \
    && bash install.sh \
    && popd

RUN ~/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/install
