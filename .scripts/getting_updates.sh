BASEDIR=..

# I3 stuff
cp $HOME/.config/i3 $BASEDIR/.config -r
cp $HOME/.config/i3blocks $BASEDIR/.config -r
cp $HOME/.config/ranger $BASEDIR/.config -r

cp $HOME/.vimrc $BASEDIR/
cp $HOME/.vim/vimrcs $BASEDIR/.vim/ -r

cp $HOME/.xinitrc $BASEDIR
cp $HOME/.Xresources $BASEDIR

echo "The files were updated succesfully."



