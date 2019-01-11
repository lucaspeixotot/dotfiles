#!/bin/sh

ctags -R --exclude=.git $1
#mv tags $1
