# Initializing things

[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
setxkbmap -model abnt2 -layout br -variant abnt2


exec i3
