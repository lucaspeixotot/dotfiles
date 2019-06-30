BASEDIR=..

# Updating Xresources
cp ~/.Xresources $BASEDIR

# Updating Emacs
cp ~/.emacs.d/init.el $BASEDIR/.emacs.d/
cp ~/.emacs.d/settings.org $BASEDIR/.emacs.d/
cp ~/.emacs.d/custom-packages $BASEDIR/.emacs.d/ -r
rm $BASEDIR/.emacs.d/README.org
ln -s $BASEDIR/.emacs.d/settings.org $BASEDIR/.emacs.d/README.org

echo "The files were updated succesfully."



