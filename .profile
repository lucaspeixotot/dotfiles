# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# NNN Exports
export EDITOR=vim
export NNN_COPIER=$HOME/.config/nnn/copier.sh

# Export global variables
export TERMINAL=urxvt
export FILE_MANAGER=ranger

export ZEPHYR_BASE=$HOME/Projects/zephyr/
export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
export ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk/
export SCRIPTS=$HOME/.config/scripts
export PATH=$PATH:$SCRIPTS/


setxkbmap -model abnt2 -layout br -variant abnt2
