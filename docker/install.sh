#!/bin/bash

sed -i -r "s|^__rp_docker_path=.*|__rp_docker_path=`pwd`|g" docker.zsh
