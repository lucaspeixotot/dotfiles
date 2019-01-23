#!/bin/sh
find $1 | entr ctags_exec.sh $1
