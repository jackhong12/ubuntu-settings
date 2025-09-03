source ~/.zsh/zlib.zsh
zinclude "cd.zsh"
zinclude "prun.zsh"

DIR=$(zlib_repo_path)/docker

# dls {{{
# show all docker image
dls () {

}

#}}} dls

# docker_build_current_folder: Build docker image accroding Dockerfile under current folder {{{

# TODO: use buildx instead.
docker_build_current_folder () {
  current_folder=${PWD:t}
  _pushd $(zlib_repo_path)
  prun ls

  prun docker build .                      \
    --file $DIR/$current_folder/Dockerfile \
    --build-arg usern=$USER                \
    --build-arg USER_UID=$(id -g $USER)    \
    --build-arg USER_GID=$(id -g $USER)    \
    -t $current_folder                     \
    $@

  _popd # $(zlib_repo_path)
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

# docker_run_bash: Run a bash in docker with --rm option {{{

docker_run_bash () {
  img=$1
  current_folder=${PWD:t}
  mkdir -p docker_history
  touch docker_history/.bash_history
  prun docker run                                    \
    -it                                              \
    --rm                                             \
    -e "TERM=xterm-256color"                         \
    -e DISPLAY=$DISPLAY                              \
    -v /tmp/.X11-unix/:/tmp/.X11-unix/               \
    -v $(pwd)/docker_history/:/home/$USER/share      \
    -v $(pwd):/home/$USER/$current_folder            \
    --network host                                   \
    --detach-keys="ctrl-@"                           \
    --privileged=true                                \
    $img                                             \
    bash
}
#}}} docker_run_bash
