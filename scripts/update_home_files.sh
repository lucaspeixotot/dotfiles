#!/bin/bash sh

BASEDIR=..

# Updating dotfiles
cp ~/.Xresources $BASEDIR && cp ~/.zshrc $BASEDIR && cp ~/.xsessionrc $BASEDIR
if [ $? -eq 0 ]
then
    echo "The home files were updated successfully!"
fi




