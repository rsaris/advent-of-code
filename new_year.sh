#!/bin/bash

echo what year?
read year
mkdir $year
mkdir $year/inputs
mkdir $year/lib
cp ./read_file.rb ./$year/lib

git add $year
git commit -a -m "$year initial commit"
