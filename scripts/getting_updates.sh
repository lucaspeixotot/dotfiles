BASEDIR=..

# Updating dotfiles
cp ~/.Xresources $BASEDIR
cp ~/.xinitrc $BASEDIR
cp ~/.bashrc $BASEDIR
cp ~/.profile $BASEDIR
cp ~/.bash_profile $BASEDIR
cp ~/.env_variables $BASEDIR
cp ~/.zshrc $BASEDIR

cp ~/.emacs.d/init.el $BASEDIR/.emacs.d/
cp ~/.emacs.d/config.org $BASEDIR/.emacs.d/
cp ~/.emacs.d/custom_packages $BASEDIR/.emacs.d/ -r
cp ~/.emacs.d/snippets $BASEDIR/.emacs.d/ -r
rm $BASEDIR/.emacs.d/README.org
ln -s $BASEDIR/.emacs.d/config.org $BASEDIR/.emacs.d/README.org

# Update I3
cp ~/.config/i3 $BASEDIR/.config/ -r

echo "The files were updated succesfully."



