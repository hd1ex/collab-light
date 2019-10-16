#!/bin/bash
function get_hash() {
    echo "$1" | md5sum | cut -f1 -d " "
}

name="$(hostname)@$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | tail -n 1)"
echo $name
echo "$name:$(get_hash $name):$1" | ncat localhost 7777
