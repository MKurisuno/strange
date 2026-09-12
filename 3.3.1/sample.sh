#!/bin/zsh

cd "$(dirname "$0")"
#echo $0
list=$(ls *.cpp)
#echo $list

for i in $list ; do
    echo $i
done
