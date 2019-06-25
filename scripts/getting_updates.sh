BASEDIR=..

# Updating Xresources
cp ~/.Xresources $BASEDIR

# Updating Emacs
cp ~/.emacs.d/init.el $BASEDIR/.emacs.d/
cp ~/.emacs.d/custom-packages $BASEDIR/.emacs.d/ -r

echo "The files were updated succesfully."



