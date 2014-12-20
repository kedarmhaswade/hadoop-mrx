#!/bin/bash
set -o nounset
set -o errexit

# Downloads the gutenberg books (text) after downloading the offsets
# Needs curl

# shows usage
usage() {
  echo "Usage: $0 low hi (low: is the lower offset: e.g. 0, hi is high offset)"
}
if [[ $# -lt 2 || ( $1 -lt 0 || $2 -lt $1 ) ]];
then 
  usage
  exit 1
fi
# use realpath
echo "Downloading from offset: $1 to offset: $2"
./download-gutenberg.rb $1 $2
