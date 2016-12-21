#!/bin/sh

SHORT_OPTS="h"

usage() {
cat <<EOF
usage: $0 [ options ] [ file ... ]

convert a text file, usuall a shell script, 
to an AWS "join-list" of strings

embedded sequences of the form {Ref:Name} => { "Ref" : "Name" }

options
  -h   print this usage

EOF
}

while getopts ":$SHORT_OPTS" opt; do
  case $opt in
       h) usage; exit 0 ;;
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

cat $* | sed -e 's/"/\\"/g' \
    -e 's/^/"/' \
    -e 's/{[[:space:]]*Ref[[:space:]]*:[[:space:]]*\([^}]*\)[[:space:]]*}/",{ "Ref" : "\1" }, "/g' \
    -e 's/$/","\\n",/' \
    -e '$s/,$//'

# ChangeLog
#
# 2014-02-12 0.0.1 SGC initial version
