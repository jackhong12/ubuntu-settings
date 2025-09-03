source ~/.zsh/zlib.zsh
zinclude "prun.zsh"


DIR=$(zlib_repo_path)/docker
DOCKERFILE=$DIR/Dockerfile.lite
IMG_LITE=ubuntu20_lite

# dls {{{
# show all docker image
dls () {

}

#}}} dls

# docker_build_current_folder: Build docker image accroding Dockerfile under current folder {{{

docker_build_current_folder () {
  current_folder=${`pwd`:t}
  prun docker build .                   \
    --file $DOCKERFILE                  \
    --build-arg usern=$USER             \
    --build-arg USER_UID=$(id -g $USER) \
    --build-arg USER_GID=$(id -g $USER) \
    -t $current_folder
}

# }}} docker_build_current_folder

# drm {{{
# Stop all containers and clean images
drm () {
  set -x
  # stop all containers
  docker stop $(docker ps -a -q)
  docker rm $(docker ps -a -q)

  # remove all images
  docker system prune -a
}

#}}} drm

# drunlite {{{

drunlite () {
  img=$IMG_LITE
  docker run                                         \
    -it                                              \
    --rm                                             \
    -e "TERM=xterm-256color"                         \
    -e DISPLAY=$DISPLAY                              \
    -v /tmp/.X11-unix/:/tmp/.X11-unix/               \
    -v $(pwd):/home/jack/share                       \
    --network host                                   \
    --detach-keys="ctrl-@"                           \
    --privileged=true                                \
    $img                                             \
    bash
}
#}}} drunlite
