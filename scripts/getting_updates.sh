BASEDIR=..

# Updating Xresources
cp ~/.Xresources $BASEDIR
cp ~/.bashrc $BASEDIR
cp ~/.profile $BASEDIR
cp ~/.env_variables $BASEDIR

# Updating Emacs
cp ~/.emacs.d/init.el $BASEDIR/.emacs.d/
cp ~/.emacs.d/settings.org $BASEDIR/.emacs.d/
cp ~/.emacs.d/custom-packages $BASEDIR/.emacs.d/ -r
cp ~/.emacs.d/snippets $BASEDIR/.emacs.d/ -r
rm $BASEDIR/.emacs.d/README.org
ln -s $BASEDIR/.emacs.d/settings.org $BASEDIR/.emacs.d/README.org

cp ~/.emacs-style.d/init.el $BASEDIR/.emacs-style.d/
cp ~/.emacs-style.d/config.org $BASEDIR/.emacs-style.d/
cp ~/.emacs-style.d/custom_packages $BASEDIR/.emacs-style.d/ -r
cp ~/.emacs-style.d/snippets $BASEDIR/.emacs-style.d/ -r
rm $BASEDIR/.emacs-style.d/README.org
ln -s $BASEDIR/.emacs-style.d/config.org $BASEDIR/.emacs-style.d/README.org

# Update I3
cp ~/.i3 $BASEDIR -r



echo "The files were updated succesfully."



