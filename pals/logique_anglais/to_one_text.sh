#!/bin/bash

path1=$1
path2=$2

ls $path1 > ./$path1"_name.txt" # get file name of floder1
ls $path2 > ./$path2"_name.txt" # get file name of floder2

while read name;
do
    cat "./$path1/$name" >> "./all_$path1.txt"
done < "./$path1.txt"

while read name;
do
    cat "./$path2/$name" >> "./all_$path2.txt"
done < "./$path2.txt"
