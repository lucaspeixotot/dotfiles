#!/bin/bash

BASEDIR=..

cp $HOME/.vimrc $BASEDIR/
cp $HOME/.vim/vimrcs $BASEDIR/.vim/ -r
cp $HOME/.vim/colors $BASEDIR/.vim/ -r
cp $HOME/.vim/autoload $BASEDIR/.vim/ -r

cp $HOME/.bashrc $BASEDIR
cp $HOME/.profile $BASEDIR
cp $HOME/.xinitrc $BASEDIR
cp $HOME/.Xresources $BASEDIR
cp $HOME/.inputrc $BASEDIR
cp $HOME/.bash_profile $BASEDIR

cp $HOME/.i3 $BASEDIR -r
cp $HOME/.config/ranger $BASEDIR/.config -r
cp $HOME/.config/scripts $BASEDIR/.config -r

echo "The files were updated succesfully."
