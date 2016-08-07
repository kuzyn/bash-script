#!/bin/bash
#
#"website grabber"
#use wget to make offline copies of website, using a "directory" website
#
#samcousin at gmail dot com
#2011


#*****
#Variables
#*****
dir=$1 #"directory" website
stuName= #student name

#*****
#Setup
#*****
if [ $# -eq 0 ]
then
echo USAGE: `basename $0` [directory website] [destination folder]
exit 1
fi

#*****
#Functions
#*****
function list() {
i=0
rm -r /tmp/htmlgrab
mkdir /tmp/htmlgrab
cd /tmp/htmlgrab
wget $dir
grep -A100 WEBSITES *.h* >> nameANDurl.txt

while [ "${i}" -ne "100" ];
do
let stuName="`head -n${i} /tmp/htmlgrab/nameANDurl.txt | grep -B1 "<br />"|tail -n1`"
echo stuName
let i+=1
done
}
#function grab() {
#}

#*****
#Script
#*****
list
exit 0
