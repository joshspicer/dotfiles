#!/bin/bash

# Run this script from its directory to symlink everything in arr to your ~ dir.
# Named something cryptic so Codespaces does their default symlinking for me!

declare -a arr=(".common" ".bashrc" ".zshrc" ".vimrc" ".gitconfig")

for i in "${arr[@]}"
do
   ln -s `pwd`/$i ~/$i
done
