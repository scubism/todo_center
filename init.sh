#!/bin/sh

set -e

available_repos=()

install_dockernize() {
  if [ ! -e "/usr/local/bin/dockerize" ]; then
    echo "Installing dockernize.."
    wget https://github.com/jwilder/dockerize/releases/download/v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz -P /tmp
    sudo tar -C /usr/local/bin -xzvf /tmp/dockerize-linux-amd64-v0.2.0.tar.gz
    rm /tmp/dockerize-linux-amd64-v0.2.0.tar.gz
  fi
}

load_config() {
  # include parse_yaml function
  . scripts/parse_yaml.sh

  # read config files
  eval $(parse_yaml config/config.yml "config_")
  if [ -e "config/config-local.yml" ]; then
    eval $(parse_yaml config/config-local.yml "config_")
  fi

  # set your local ip to the host variable when it's empty
  if [ "$config_host" = "" ]; then
    export config_host=$(ip addr | grep -E "192\.|100\." | awk '{print $2}' | sed 's/\/.*$//')
  fi

  echo "=== variables ==="
  printenv | grep config_
  echo "================="

  local repos=($(printenv | grep '^config_.\+_git_url=.\+$' | sed "s/^config_//g" | sed "s/_git_url=.\+$//g"));

  for ((i = 0; i < ${#repos[@]}; i++)) {
      local confname="config_${repos[i]}_enabled"
      if [ ${!confname} != "false" ]; then
        available_repos=("${available_repos[@]}" ${repos[i]})
      fi
  }

  echo "=== available repos ==="
  for ((i = 0; i < ${#available_repos[@]}; i++)) {
      echo "${available_repos[i]}"
  }
  echo "======================="
}

generate_docker_compose_file() {
  eval $(dockerize -template config/docker-compose-template.yml:docker-compose.yml)
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
  echo $repo
  if [ ! -d $repo ]; then
    git clone $url $repo
  fi
}

clone_repos() {
  for ((i = 0; i < ${#available_repos[@]}; i++)) {
      clone_repo ${available_repos[i]}
  }
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

echo "Finished!"
