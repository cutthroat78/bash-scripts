#!/bin/bash

ext_menu="dmenu"

while true; do
  link=$(curl -Ls -o /dev/null -w %{url_effective} "$1")
  firefox "$link"

  opinion=$(echo -e "f\nl\no\nd" | $ext_menu -p "Favourite, Like, OK or Dislike? (f,l,o,d)")

  sleep 2

  if [[ -z "$opinion" ]]; then
    break
  fi

  if [ "$opinion" = "f" ]; then
    opinion="Favourite"
  fi

  if [ "$opinion" = "l" ]; then
    opinion="Like"
  fi

  if [ "$opinion" = "o" ]; then
    opinion="OK"
  fi

  if [ "$opinion" = "d" ]; then
    opinion="Dislike"
  fi

  echo "$link,$opinion" >> "$2".csv

done
