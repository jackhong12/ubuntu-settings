#> docker: Docker usage {{{
# - dls: show all docker images
#   $ dls
#
# - dinstall: install docker images
#   $ dinstall
#
# - drm: remove all images
#   $ drm
#
# - drunlite: run simple docker
#   $ drunlite

__rp_root=root_needed_to_replaced
DIR=$__rp_root/docker
DOCKERFILE=$DIR/Dockerfile.lite
IMG_LITE=ubuntu20_lite

# dls {{{
# show all docker image
dls () {

}

#}}} dls

# dinstall {{{

dinstall () {
  docker build .                        \
    --file $DOCKERFILE                  \
    --build-arg USER_UID=$(id -g $USER) \
    --build-arg USER_GID=$(id -g $USER) \
    -t $IMG_LITE
}
#}}} dinstall

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

#}}} docker
