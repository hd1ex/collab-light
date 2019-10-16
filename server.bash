#!/bin/bash

ncat -l -k -p 7777 | bash decoder.bash  | while read command ; do
  echo "Turning $command..."
  case "$command"
  in
    on) $1;;
    off) $2;;
  esac
done
