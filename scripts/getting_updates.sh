BASEDIR=..

# Updating dotfiles
cp ~/.Xresources $BASEDIR
cp ~/.xinitrc $BASEDIR
cp ~/.bashrc $BASEDIR
cp ~/.profile $BASEDIR
cp ~/.env_variables $BASEDIR
cp ~/.zshrc $BASEDIR
cp ~/.xsessionrc $BASEDIR

# Update I3
cp ~/.config/i3 $BASEDIR/.config/ -r

# Update urxvt perl
cp ~/.config/urxvt-perl $BASEDIR/.config/-r

# Update Polybar config
cp ~/.config/polybar $BASEDIR/.confg/-r

echo "The files were updated succesfully."



