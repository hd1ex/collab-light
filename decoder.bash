#!/bin/bash

function get_hash() {
    echo "$1" | md5sum | cut -f1 -d " "
}

DIR=$(mktemp -d)

trap cleanup INT

function cleanup() {
   >&2 echo ""
   rm -r "$DIR"
   exit
}

function switch() {
  if [[ -n "$(ls $DIR)" ]]; then 
      echo "on"
  else
      echo "off"
  fi
}

while read line
do
  >&2 echo "Got '$line'"
  args="$(echo $line | tr ':' $'\n')"

  # Check for 3 args
  if [[ $(echo "$args" | wc -l) != 3 ]]; then
    continue
  fi

  key=$(echo "$args" | sed -n '1p')
  chk=$(echo "$args" | sed -n '2p')
  cmd=$(echo "$args" | sed -n '3p')

  # Validate hash
  if [[ "$chk" != "$(get_hash $key)" ]]; then
    continue
  fi

  name="$DIR/$key"

  case "$cmd"
  in
    0) test -e $name && rm "$name";;
    1) touch "$name";;
  esac

  switch

done

cleanup
