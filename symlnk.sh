#!/bin/bash

declare -a arr=(".common" ".bashrc" ".zshrc" ".vimrc" ".gitconfig")

for i in "${arr[@]}"
do
   ln -s `pwd`/$i ~/$i
done