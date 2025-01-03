#!/usr/bin/env sh

if [ "$1" = "daemon" ];  then 
    exec crond -n -s -m off 
else 
    exec -- "$@"
fi