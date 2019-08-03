BASEDIR=..

# Updating dotfiles
cp ~/.Xresources $BASEDIR
cp ~/.xinitrc $BASEDIR
cp ~/.bashrc $BASEDIR
cp ~/.profile $BASEDIR
cp ~/.bash_profile $BASEDIR
cp ~/.env_variables $BASEDIR
cp ~/.zshrc $BASEDIR

cp ~/.emacs-style.d/init.el $BASEDIR/.emacs-style.d/
cp ~/.emacs-style.d/config.org $BASEDIR/.emacs-style.d/
cp ~/.emacs-style.d/custom_packages $BASEDIR/.emacs-style.d/ -r
cp ~/.emacs-style.d/snippets $BASEDIR/.emacs-style.d/ -r
rm $BASEDIR/.emacs-style.d/README.org
ln -s $BASEDIR/.emacs-style.d/config.org $BASEDIR/.emacs-style.d/README.org

# Update I3
cp ~/.i3 $BASEDIR -r


echo "The files were updated succesfully."



