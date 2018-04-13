#!/bin/bash

# Set up Neovim config
NVIM_DIRECTORY=~/.config/nvim
NVIM_INIT=./init.vim

if [ ! -d "$NVIM_DIRECTORY" ]; then
  mkdir -p $NVIM_DIRECTORY
fi

#if [ -f "$NVIM_DIRECTORY/init.vim" ]; then
#  rm -f $NVIM_DIRECTORY/init.vim
#fi

#ln -s ./init.nvim $NVIM_DIRECTORY/init.vim
