#!/bin/sh
pkill -f "entr ctags_exe.sh" && exit
find $1 | entr ctags_exec.sh $1
