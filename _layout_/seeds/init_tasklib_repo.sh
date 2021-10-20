#!/usr/bin/env bash


# echo "#= [stage=resolve-deps]"
_CUR_PATH_="epath:"
_CUR_STAGE_="resolve-deps"; _CUR_PATH_="$_CUR_PATH_/$_CUR_STAGE_"

    _CUR_STEP_="task-tool"; _CUR_PATH_="$_CUR_PATH_/$_CUR_STEP_"
    
    if which task &>/dev/null ; then
        echo "#-- [status _is_ ok   ] [step _is_ $_CUR_STEP_]  [reason _is_ Found task executor] [epath _is_ $_CUR_PATH_]" 
    else
        echo "#-- [status _is_ fail ] [step _is_ $_CUR_STEP_]  [reason _is_ Missing task executor] [epath _is_ $_CUR_PATH_]" 
        echo '    
    !!! fail "task tool is required"

        for installation instructions follow:
        > https://taskfile.dev/#/installation

        for releases page (its drop-in standalone single executable):
        > https://github.com/go-task/task/releases
    '
        echo "#-- [status _is_ fail ] [step _is_ $_CUR_STEP_]  [reason _is_ Missing task executor] [epath _is_ $_CUR_PATH_]"
        exit 1
    fi
    _CUR_PATH_=$(dirname $_CUR_PATH_)
_CUR_PATH_=$(dirname $_CUR_PATH_)


_me_parent_path_=$(dirname $0)

if [[ "$WINDIR" != "" ]]; then
    repo_root_path=$(git -C $_me_parent_path_ rev-parse --show-toplevel | repo_root_path=sed -e 's/\//\\\\/g' )
else
    repo_root_path=$(git -C $_me_parent_path_ rev-parse --show-toplevel) 
fi

echo "Will work in $repo_root_path"
cd "$repo_root_path"

cat <<EQF > "Taskfile.yml"
version: "3"
vars:
  _project_name_: "$(basename $repo_root_path)"
tasks:
  default: [task info]

  info:
    desc: "Repo Information: {{._project_name_}}"
    silent: true
    cmds:
    - |-
      echo "
      _project_name_: {{._project_name_}}
      "
EQF

echo "[status _is_ ok] [artifacts _are_ Taskfile.yml _at_ $(pwd)]"
