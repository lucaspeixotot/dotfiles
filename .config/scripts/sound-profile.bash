#!/bin/bash

arg=$1

if [ $arg == "hdmi" ]; then
    #notify-send "Setando o profile do áudio para HDMI."
    rm $HOME/.asoundrc
    cp $HOME/.asoundrc-hdmi $HOME/.asoundrc
    alsactl restore
else
    #notify-send "Setando o profile do áudio para default."
    rm $HOME/.asoundrc
    cp $HOME/.asoundrc-default $HOME/.asoundrc
    alsactl restore
fi
