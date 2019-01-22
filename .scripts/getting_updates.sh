BASEDIR=..

# I3 stuff
cp $HOME/.config/i3 $BASEDIR/.config -r
cp $HOME/.config/i3blocks $BASEDIR/.config -r
cp $HOME/.config/ranger $BASEDIR/.config -r
cp $HOME/.config/nnn $BASEDIR/.config -r
cp $HOME/.config/compton.conf $BASEDIR/.config

cp $HOME/.vimrc $BASEDIR/
cp $HOME/.vim/vimrcs $BASEDIR/.vim/ -r

cp $HOME/.bashrc $BASEDIR
cp $HOME/.profile $BASEDIR
cp $HOME/.xinitrc $BASEDIR
cp $HOME/.Xresources $BASEDIR
cp $HOME/.inputrc $BASEDIR
cp $HOME/.bash_profile $BASEDIR

echo "The files were updated succesfully."



