BASEDIR=..

# Updating dotfiles
cp ~/.Xresources $BASEDIR
cp ~/.xinitrc $BASEDIR
cp ~/.bashrc $BASEDIR
cp ~/.profile $BASEDIR
cp ~/.bash_profile $BASEDIR
cp ~/.env_variables $BASEDIR
cp ~/.zshrc $BASEDIR


# Update I3
cp ~/.config/i3 $BASEDIR/.config/ -r

echo "The files were updated succesfully."



