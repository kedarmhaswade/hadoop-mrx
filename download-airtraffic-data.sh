#!/bin/bash
set -o nounset
set -o errexit

# Downloads the airtraffic data only if it does not exist
# Needs wget

# shows usage
usage() {
  echo "Usage: $0 <year to download for> (year between 1987 and 2008)"
}
if [[ $# -eq 0 || ( $1 -gt 2008 || $1 -lt 1987 ) ]];
then 
  usage
  exit 1
fi
YEAR=$1
FILE=${YEAR}.csv.bz2
if [[ -f $FILE ]];
then
  echo "skipping, ${FILE} already exists"
  exit 0
fi
URL="http://stat-computing.org/dataexpo/2009/${FILE}"
wget ${URL}
