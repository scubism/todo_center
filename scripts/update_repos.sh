#!/bin/bash

set -e

read -p "Are you sure to execute update_all_repos.sh? [Yy] " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  exit 1
fi

. scripts/load_conf.sh

BASE_DIR=$(dirname $0)/..
cd $BASE_DIR

update_repo() {
  local repo=$1
  local conf_url="config_${repo}_git_url"
  local conf_branch="config_${repo}_git_branch"
  local conf_submodule="config_${repo}_git_submodule"

  url=${!conf_url}
  branch=${!conf_branch:-'master'}
  has_submodule=${!conf_submodule:-'false'}

  if [ -d $repo ]; then
    echo "=== Updating $repo ==="
    cd $repo

    local local_branch=`git rev-parse --verify --quiet $branch`
    if [ "$local_branch" = "" ]; then
      git fetch origin
      git checkout -b $branch origin/$branch
    else
      git pull origin $branch
    fi

    if [ $has_submodule = 'true' ]; then
      echo "=== Updating git submodules of $repo ==="
      git submodule update
    fi

    cd ..
  fi
}

update_repos() {
  for ((i = 0; i < ${#available_repos[@]}; i++)) {
    update_repo ${available_repos[i]}
  }
}

update_center() {
  echo "=== Updating Center Repo ==="
  git pull origin $config_todo_center_git_branch
}

load_config
update_center
update_repos
