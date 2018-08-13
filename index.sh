#!/bin/bash

set -e

export PATH=/usr/local/diamond:/usr/local/bin:/usr/bin

REF_BASENAME=$1

diamond makedb --in $REF_BASENAME.fna --db proteins

echo
echo
ls -al
echo
echo

