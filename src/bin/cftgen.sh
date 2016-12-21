#!/bin/bash

CFTGENHOME=${CFTOOLSHOME:=/usr/local/aws/cf}

SHORT_OPTS="r:uB:D:L:vh"

REFORMATTER="json_reformat"
UNFORMATTED=0
VERBOSE=0
VERSION="2.6.3-pre"

usage() {
cat <<EOF
usage: $0 [options] infile.cf4

options
  -r reformater    which reformatter to use [$REFORMATER]
  -u               leave output unformatted [$UNFORMATTED]
  -B               specify bin directory [$CFTGENHOME/bin]
  -D var=val       pass a definition into m4
  -L               specify lib directory [$CFTGENHOME/lib]
  -v verbose
  -h               help (display this)

Version: $VERSION

EOF
}
#
# Process Command Line options
#

prog=`basename $0`
DEFINES=""

while getopts ":$SHORT_OPTS" opt; do
  case $opt in
       u) UNFORMATTED=1 ;;
       r) REFORMATTER=FILE="$OPTARG" ;;
       B) CFTBINDIR="$OPTARG" ;;
       D) DEFINES="$DEFINES -D$OPTARG" ;;
       L) CFTLIBDIR="$OPTARG" ;;
       h) usage; exit 0 ;;
       v) VERBOSE=1 ;;
       :) echo "Option -$OPTARG requires an argument." >&2
          exit 1
          ;;
      \?) echo "Invalid option: -$OPTARG" >&2
          usage
          exit 1
          ;;
   esac
done

shift $(($OPTIND - 1))

if [ $# -lt 1 ]; then
  echo "$prog:error:must specify source"
  usage
  exit 1
fi

# initialize the BIN and LIB dirs if they were not set via commmand line
CFTBINDIR=${CFTBINDIR:-$CFTGENHOME/bin}
CFTLIBDIR=${CFTLIBDIR:-$CFTGENHOME/lib}


if [ -z "$CFTOOLSHOME" ]; then
  echo >&2 "$0:error:must set CFTOOLSHOME"
  exit 1
fi

if [ ! -d "$CFTOOLSHOME" ]; then
  echo >&2 "$prog:error: CFTOOLSHOME ($CFTOOLSHOME) is not a directory"
  exit 1
fi

if [ -z "$CFTBINDIR" -o ! -d "$CFTBINDIR" ]; then
  echo >&2 "$prog:error: CFTBINDIR ($CFTBINDIR) is missing or not a directory"
  exit 1
fi

if [ -z "$CFTLIBDIR" -o ! -d "$CFTLIBDIR" ]; then
  echo >&2 "$prog:error: CFTLIBDIR ($CFTLIBDIR) is missing or not a directory"
  exit 1
fi


# process the specified files thru m4

FORMATTER="cat"
if [ $UNFORMATTED = 0 ]; then
    # make sure the reformatter exists
    if which $REFORMATTER > /dev/null 2>&1 ; then
	FORMATTER=$REFORMATTER
    else
	echo >&2 "$prog:warning: reformatter $REFORMATTER not found"
    fi
fi

m4 -I $CFTLIBDIR $CFTLIBDIR/mkTemplate.m4 $DEFINES $@ | \
    $CFTBINDIR/stripcomments | $FORMATTER

# json_reformat comes with the yajl package
# it will pretty print json, preserving the key order
