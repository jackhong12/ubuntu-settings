#!/bin/zsh


# zsh-remove-path
# zsh-remove-path [file]

zsh-remove-path () {
    if [ "$#" -ne 1 ]; then
        echo "zsh-remove-path [file]"
        return 1
    fi
    sed -i -r "s|^(__rp_)([0-9a-zA-Z_]+)=.*|\1\2=\2_needed_to_replaced|g" $1
}
