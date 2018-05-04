#!/bin/bash

# Directory where Neovim plugins are written
nvim_plugins=~/.config/nvim/bundle

# This file has a list of the plugins that we want installed
packages=~/dev_config/neovim/packages.txt

# An array of the plugins that are supposed to be installed
plugin_list=()

# This will delete any plugins that aren't supposed to be installed anymore
clean_plugins () {
  # For each plugin that's currently installed
  for plugin in $(ls $nvim_plugins); do
    # Check if it SHOULD be installed
    if [[ ! "${plugin_list[@]}" =~ "$plugin" ]]; then
      # If not delete it
      printf "Deleting %s\n" $plugin
      rm -rf $nvim_plugins/$plugin
      printf "\n"
    fi
  done
}

# This will load a plugin from GitHub
# Use like this: load_plugin "username/repo -- [post install script]"
load_plugin () {
  # The GitHub account for the plugin
  account=$( echo $1 | cut -d'/' -f1 )

  # The GitHub repo name for the plugin
  plugin=$( echo $1 | cut -d'/' -f2 )

  # An optional post-installation script
  script=$( echo $@ | awk '{split($0, a, "--"); print a[2]}' )

  # If the plugin hasn't been loaded load it
  if [ ! -d $nvim_plugins/$plugin ]; then
    printf "Loading %s\n" $1
    git clone git://github.com/$account/$plugin $nvim_plugins/$plugin
    printf "\n"
  else
    printf "Updating %s\n" $1
    cd $nvim_plugins/$plugin
    git pull
    printf "\n"
  fi

  # Execute additional commands
  if [ ! -z "$script" ]; then
    printf "Executing post-install script:\n"
    eval "$script"
    printf "\n"
  fi

  # Append to the plugin list array
  plugin_list+=("$plugin")
}

# Check if Git is installed
command -v git >/dev/null 2>&1
if [ ! $? -eq 0 ]; then
  printf "Git must be installed to run this script. Aborting.\n"
  exit 1
fi

printf "Loading Neovim plugins:\n\n"

while IFS= read plugin; do
  load_plugin $plugin
done < $packages

clean_plugins

printf "Finished loading Neovim plugins.\n\n"
