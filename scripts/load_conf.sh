#!/bin/sh

set -e

available_repos=()

load_config() {
  # include parse_yaml function
  source scripts/parse_yaml.sh

  # read config files
  eval $(parse_yaml config/config.yml "config_")
  if [ -e "config/config-local.yml" ]; then
    eval $(parse_yaml config/config-local.yml "config_")
  fi

  # set your local ip to the host variable when it's empty
  if [ "$config_host" = "" ]; then
    export config_host=$(ip addr | grep -E "192\.|10\.10" | awk '{print $2}' | sed 's/\/.*$//')
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
