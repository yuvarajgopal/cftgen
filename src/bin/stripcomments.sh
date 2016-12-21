#!/bin/sh

# remove all full line comments starting with #
# remove all full line comments that start with //
# remove all leading white space from lines
# remove all empty lines

cat $@ | sed -e '/^[ \t]*#/d' \
    -e '/^[ \t]*\/\//d' \
    -e 's/^[ \t]*//' \
    -e '/^$/d'

