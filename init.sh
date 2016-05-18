#!/bin/sh

set -e

source scripts/load_conf.sh

install_dockernize() {
  if [ ! -e "/usr/local/bin/dockerize" ]; then
    echo "Installing dockernize.."
    wget https://github.com/jwilder/dockerize/releases/download/v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz -P /tmp
    sudo tar -C /usr/local/bin -xzvf /tmp/dockerize-linux-amd64-v0.2.0.tar.gz
    rm /tmp/dockerize-linux-amd64-v0.2.0.tar.gz
  fi
}

generate_docker_compose_file() {
  eval $(dockerize -template config/docker-compose-template.yml:docker-compose.yml)
  eval $(dockerize -template config/docker-compose-dev-template.yml:docker-compose-dev.yml)
}

make_data_dirs() {
  # For MariaDB
  if [ ! -d "/var/volume_todo/mariadb" ]; then
    sudo mkdir -p /data/mariadb/data
    sudo mkdir -p /data/mariadb/conf
  fi

  # For MongoDB
  if [ ! -d "/var/volume_todo/mariadb" ]; then
    sudo mkdir -p /data/mongo/db
    sudo mkdir -p /data/mongo/configdb
  fi
}

clone_repo() {
  local repo=$1
  local confname="config_${repo}_git_url"
  url=${!confname}
  if [ ! -d $repo ]; then
    git clone $url $repo
  fi
}

clone_repo() {
  local repo=$1
  local confname="config_${repo}_git_url"
  url=${!confname}
  if [ ! -d $repo ]; then
    git clone $url $repo
  fi
}

clone_repos() {
  for ((i = 0; i < ${#available_repos[@]}; i++)) {
      clone_repo ${available_repos[i]}
  }
}

setup_repo() {
  local repo=$1
  local conf_url="config_${repo}_git_url"
  local conf_branch="config_${repo}_git_branch"
  local conf_submodule="config_${repo}_git_submodule"

  url=${!conf_url}
  branch=${!conf_branch:-'master'}
  has_submodule=${!conf_submodule:-'false'}

  if [ -d $repo ]; then
    echo "=== Setting up $repo ==="
    cd $repo

    local local_branch=`git rev-parse --verify --quiet $branch`
    if [ "$local_branch" = "" ]; then
      git fetch origin
      git checkout -b $branch origin/$branch
    else
      git pull origin $branch
    fi

    if [ $has_submodule = 'true' ]; then
      echo "=== Getting submodules of $repo ==="
      git submodule init
      git submodule update
    fi

    cd ..
  fi
}

setup_repos() {
  for ((i = 0; i < ${#available_repos[@]}; i++)) {
      setup_repo ${available_repos[i]}
  }

  # Special case
  if [ $config_todo_api_gateway_enabled != "false" ]; then
    if [ ! -e "todo_api_gateway/server.crt" ]; then
      echo 'generate self certs..'
      ./todo_api_gateway/scripts/generate_self_certs.sh
    fi
  fi
}

# ==============================================================================
# Main
# ==============================================================================

echo "Start"

install_dockernize
load_config
generate_docker_compose_file
make_data_dirs
clone_repos
setup_repos

echo "Finished!"

