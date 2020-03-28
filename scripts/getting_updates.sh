BASEDIR=..

# Updating dotfiles
cp ~/.Xresources $BASEDIR
cp ~/.xinitrc $BASEDIR
cp ~/.bashrc $BASEDIR
cp ~/.profile $BASEDIR
cp ~/.zshrc $BASEDIR
cp ~/.xsessionrc $BASEDIR

# Update I3
cp ~/.config/i3 $BASEDIR/.config/ -r

# Update urxvt perl
cp ~/.config/urxvt-perl $BASEDIR/.config/ -r

# Update Polybar config
cp ~/.config/polybar $BASEDIR/.config/ -r

# Update env and scripts
cp ~/.config/scripts $BASEDIR/.config/ -r
cp ~/.config/env $BASEDIR/.config/

# Update compton config
cp ~/.config/compton.conf $BASEDIR/.config/

echo "The files were updated succesfully."



