#!/bin/bash

day=$1
month=$2
year=$3
time=$4 # 07:00
med=$5

if [ $1 = today ]; then
  day=$(date +"%d")
  month=$(date +"%m")
  year=$(date +"%Y")
  time=$2
  med=$3
fi
if [ $1 = yesterday ]; then
  day=$(date --date="yesterday" +"%d")
  month=$(date +"%m")
  year=$(date +"%Y")
  time=$2
  med=$3
fi
if [ $1 = now ]; then
  day=$(date +"%d")
  month=$(date +"%m")
  year=$(date +"%Y")
  time=$(date +"%H:%M")
  med=$2
fi

if [ ! -f ./$year/$month-$year/$day-$month-$year.txt ]; then
  mkdir ./$year
  mkdir ./$year/$month-$year
fi

if [ $med = "hista" ]; then
  source ./anti-histamine
fi

if [ $med = "moist" ]; then
  source ./moisturiser
fi

if [ $med = "b12" ]; then
  med="Vitamin B12"
fi

echo  "$time - $med" >> ./$year/$month-$year/$day-$month-$year.txt
