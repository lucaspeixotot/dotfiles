BASEDIR=..
vimrc_file="$HOME/.vimrc"
vim_home="$HOME/.vim/"

if [ -f "$vimrc_file" ]
then
    mv $vimrc_file $HOME/.vimrc-backup
fi

if [ -d "$vim_home" ];
then
    mv $vim_home $HOME/.vim-backup/
fi

cp $BASEDIR/.vimrc $HOME/
cp $BASEDIR/.vim $HOME/ -r
vim +'PlugInstall --sync' +qa
sh $BASEDIR/.scripts/vim_patch_mru.vim
echo "Vim installed."
