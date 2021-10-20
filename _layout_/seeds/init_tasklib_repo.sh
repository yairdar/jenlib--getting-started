#!/usr/bin/env bash

# "run with bash _layout_/seeds/init_tasklib_repo.sh _spec_:here"

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
    repo_root_path=$(git -C $_me_parent_path_ rev-parse --show-toplevel | sed -e 's/\//\\\\/g' )
else
    repo_root_path=$(git -C $_me_parent_path_ rev-parse --show-toplevel) 
fi


[[ "$repo_root_path" == "" ]] \
    && echo "missing var=repo_root_path is required" \
    && exit 1

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
      \$(task -l)
      ---
      _project_name_: {{._project_name_}}
      "
EQF

task info | grep "Repo Information"

if [[ "$?" != "0" ]]; then
    echo "[status _is_ fail] [epath:/generate-files/Taskfile.yml]"
    exit 1
fi
echo "[status _is_ ok] [epath:/generate-files] [artifacts _are_ Taskfile.yml _at_ $repo_root_path]" 


# md
# ## functions
#
# ### intentation
#
# > `_origin_` [stackoverflow.com:indenting-multi-line-output-in-a-shell-script](https://stackoverflow.com/questions/17484774/indenting-multi-line-output-in-a-shell-script)

indent() { sed 's/^/  /'; }

function indented {
  local PIPE_DIRECTORY=$(mktemp -d)
  trap "rm -rf '$PIPE_DIRECTORY'" EXIT

  mkfifo "$PIPE_DIRECTORY/stdout"
  mkfifo "$PIPE_DIRECTORY/stderr"

  "$@" >"$PIPE_DIRECTORY/stdout" 2>"$PIPE_DIRECTORY/stderr" &
  local CHILD_PID=$!

  sed 's/^/  /' "$PIPE_DIRECTORY/stdout" &
  sed 's/^/  /' "$PIPE_DIRECTORY/stderr" >&2 &
  wait "$CHILD_PID"
  rm -rf "$PIPE_DIRECTORY"
}
# /md
