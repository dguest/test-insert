#!/usr/bin/env bash

set -eu

function convert-svg-to-pdf() {
    if ! hash inkscape &> /dev/null ; then
	echo "inkscape not found, quitting" 2>&1
	return 1
    fi
    local OUT=${1%.svg}.pdf
    if [[ $OUT -nt $1 ]] ; then
	echo "$OUT is newer than $1, not remaking"
	return 0
    fi
    if [[ $1 != *.svg ]] ; then
	echo "can't convert $1 to pdf with inkscape" 2>&1
	return 1
    fi
    inkscape --without-gui --export-pdf=$OUT $1
}

function get-file() {
    local BASE=$(basename $1)
    local OUT=${2-$BASE}
    if [[ -f $OUT ]]; then
	echo "already have $OUT"
    else
	echo -n "getting $1..."
	curl -s $1 -o $OUT
	echo "done"
    fi

    if [[ $OUT == *.svg ]]; then
	echo "converting $1 to .pdf"
	convert-svg-to-pdf $OUT
    fi
}

get-file http://upload.wikimedia.org/wikipedia/commons/4/4b/Standard_Model_of_Elementary_Particles_modified_version.svg standard-model.svg
get-file http://pantheon.yale.edu/~dhg3/alpha-strong.pdf