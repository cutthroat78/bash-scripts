#!/bin/bash

day=$1
month=$2
year=$3
amount=$4
description=$5

if [ $1 = today ]; then
  day=$(date +"%d")
  month=$(date +"%m")
  year=$(date +"%Y")
  amount=$2
  description=$3
fi
if [ $1 = yesterday ]; then
  day=$(date --date="yesterday" +"%d")
  month=$(date +"%m")
  year=$(date +"%Y")
  amount=$2
  description=$3
fi

if [ ! -f ./$year/$month-$year/$day-$month-$year.md ]; then
  mkdir ./$year
  mkdir ./$year/$month-$year
  echo -e "| Date | Amount | Description |\n|-|-|-|" > ./$year/$month-$year/$day-$month-$year.md
fi
echo "| $day-$month-$year | $amount | $description |" >> ./$year/$month-$year/$day-$month-$year.md
glow ./$year/$month-$year/$day-$month-$year.md
amount=$(echo "$amount" | sed "s/€/\\ /g")
source ./Total
total=$(expr $total $amount)
echo "Total Amount: $total"
echo "total=$total" > ./Total
