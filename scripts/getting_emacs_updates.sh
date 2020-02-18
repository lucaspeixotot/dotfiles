cp ~/.emacs.d/init.el $BASEDIR/.emacs.d/
cp ~/.emacs.d/config.org $BASEDIR/.emacs.d/
cp ~/.emacs.d/custom_packages $BASEDIR/.emacs.d/ -r
cp ~/.emacs.d/snippets $BASEDIR/.emacs.d/ -r
rm $BASEDIR/.emacs.d/README.org
ln -s $BASEDIR/.emacs.d/config.org $BASEDIR/.emacs.d/README.org

echo "Emacs files was updated!"

