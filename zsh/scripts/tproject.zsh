#!/bin/zsh

# include utils.zsh {{{
if [ -f ~/.zsh/utils.zsh ]; then
  source ~/.zsh/utils.zsh
else
  printf "\033[0;31mNot file ~/.zsh/utils.zsh\033[0m\n"
fi
# }}} include utils.zsh

# tmux_is_active: Check whether tmux is active {{{
tmux_is_active () {
  if [[ -n "$TMUX" ]]; then
    return 0
  else
    return 1
  fi
}
# }}} tmux_is_active

# tmux_show_all_sessions: Show all tmux sessions {{{
tmux_show_all_sessions () {
  echo $(tmux ls | sed -r "s|([^ ]*):.*|\1|")
}
# }}} tmux_show_all_sessions

# tmux_is_session_exist: Check whether tmux session exists {{{
tmux_is_session_exist () {
  if [[ "$#" -ne 1 ]]; then
    perror "Usage: tmux_is_session_exist [session_name]"
    return 1
  fi

  if ! tmux_is_active; then
    return 1
  fi

  for sn in $(tmux_show_all_sessions); do
    if [[ "$sn" == "$1" ]]; then
      return 0
    fi
  done
  return 1
}

# }}} tmux_is_session_exist

# tattach: Attatch to a tmux session {{{
# Usage:
#   tattach <session_name>

tattach () {
  if [ "$#" -ne 1 ]; then
    perror "Usage: tattach <session_name>"
    return 1
  fi

  if ! tmux_is_active; then
    # tmux is not active, create a new session
    tmux new -d -s $1
    tmux attach -t $1
  else
    if ! tmux_is_session_exist $1; then
      # session did not exist, create a new session
      tmux new -d -s $1
    fi
    tmux switch -t $1
  fi
}
# }}} tattach

# tentry: Attach to session entry {{{
tentry () {
  tattach entry
}

# }}} tentry

typeset -A tpvars
tpvars[root]=~/projects
tpvars[info_file]=.info

# tproject_init: Initialize a new project {{{
# Usage:
#   $ tproject_init <project_name>
tproject_init () {
  if [ "$#" -lt 1 ]; then
    perror "Usage: tproject_init <project_name>"
    return 1
  fi

  local project_name=$1
  local project_dir=$tpvars[root]/$project_name
  is_project_created=1
  if [[ ! -d $project_dir ]]; then
    # create directories
    prun mkdir -p $project_dir
    prun tmux new -d -s $project_name
    tmux send-keys -t $project_name "cd $project_dir && clear" ENTER
  fi

  if [ "$#" -eq 2 ]; then
    echo $2 > $project_dir/$tpvars[info_file]
  fi

  # attach to the new project session
  tattach $project_name
}

# }}} tproject_init

# tproject_load_all: Load all projects {{{
# Usage:
#   $ tproject_load_all

tproject_load_all () {
  if [[ ! -d $tpvars[root] ]]; then
    perror "Project root directory does not exist: ${tpvars[root]}"
    return 1
  fi

  prun tmux new -d -s entry

  for project in $(ls $tpvars[root]); do
    if [[ -d "$tpvars[root]/$project" ]]; then
      if ! tmux_is_session_exist $project; then
        # create a new session for the project
        prun tmux new -d -s $project
        tmux send-keys -t $project "cd $tpvars[root]/$project && clear" ENTER
      fi
    fi
  done

  # attach to the entry session
  tentry
}

# }}} tproject_load_all

# tproject_close_all: Close all projects {{{
# Usage:
#   $ tproject_close_all

tproject_close_all () {
  if ! tmux_is_active; then
    perror "Tmux is not active."
    return 1
  fi
  prun tmux kill-server
}

# }}} tproject_close_all

# tproject_set_var: Set tproject variable {{{
# Usage:
#   $ tproject_set_var <key> <value>
tproject_set_var () {
  if [ "$#" -ne 2 ]; then
    perror "Usage: tproject_set_var <key> <value>"
    return 1
  fi

  local key=$1
  local value=$2

  if [[ -z "$key" || -z "$value" ]]; then
    perror "Key and value cannot be empty."
    return 1
  fi

  # Only accept keys: root, info_file.
  if [[ "$key" != "root" &&
        "$key" != "info_file" ]]; then
    perror "Invalid key: $key\n".
    return 1
  fi

  tpvars[$key]=$value
  pinfo "Set tproject variable: $key = $value\n"
}

# }}} tproject_set_var

# tproject_show_vars: Show tproject variables {{{
# Usage:
#   $ tproject_show_vars

tproject_show_vars () {
  if [[ ${#tpvars[@]} -eq 0 ]]; then
    perror "No tproject variables set."
    return 1
  fi

  pinfo "TProject Variables:\n"
  for key in "${(@k)tpvars}"; do
    echo "\t$key: ${tpvars[$key]}"
  done
}

# }}} tproject_show_vars

# tproject_attach: Attach to a project {{{
# Usage:
#   $ tproject_attach <project_name>

tproject_attach () {
  if [ "$#" -ne 1 ]; then
    perror "Usage: tproject_attach <project_name>"
    return 1
  fi

  local project_name=$1
  local project_dir=$tpvars[root]/$project_name

  if [[ ! -d $project_dir ]]; then
    prun tproject_init $@
    return 0
  fi

  if ! tmux_is_session_exist $project_name; then
    # create a new session for the project
    prun tmux new -d -s $project_name
    tmux send-keys -t $project_name "cd $project_dir && clear" ENTER
  fi

  # attach to the project session
  tattach $project_name
}

_tproject_attach () {
  local -a args
  for project in $(ls $tpvars[root]); do
    project_dir=$tpvars[root]/$project
    info_path=$project_dir/$tpvars[info_file]
    if [[ -d $project_dir ]]; then
      if [[ -f $info_path ]]; then
        args+=("${project}: $(cat $info_path)")
      else
        args+=("${project}")
      fi
    fi
  done
  _describe "project names" args
}

compdef _tproject_attach tproject_attach

# }}} tproject_attach
