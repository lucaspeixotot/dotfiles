BASEDIR=..

# Updating dotfiles
cp ~/.Xresources $BASEDIR
cp ~/.xinitrc $BASEDIR
cp ~/.bashrc $BASEDIR
cp ~/.profile $BASEDIR
cp ~/.zshrc $BASEDIR
cp ~/.xsessionrc $BASEDIR
if [ $? -eq 0 ]
then
    echo "The home files were updated successfully!"
fi

# Update I3
cp ~/.config/i3 $BASEDIR/.config/ -r
if [ $? -eq 0 ]
then
    echo "I3 was updated successfully!"
fi

# Update urxvt perl
cp ~/.config/urxvt-perl $BASEDIR/.config/ -r

# Update Polybar config
cp ~/.config/polybar $BASEDIR/.config/ -r
if [ $? -eq 0 ]
then
    echo "Polybar config was updated successfully!"
fi

# Update env and scripts
cp ~/.config/scripts $BASEDIR/.config/ -r
cp ~/.config/env $BASEDIR/.config/
if [ $? -eq 0 ]
then
    echo "Scripts and env config were updated successfully!"
fi

# Update compton config
cp ~/.config/compton.conf $BASEDIR/.config/
if [ $? -eq 0 ]
then
    echo "Compton was updated successfully!"
fi

echo "The files were updated succesfully."



