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
    if [[ -f $1 ]]; then
	echo "already have $1"
    else
	echo "getting $1..."
	curl $2 > $1
    fi

    if [[ $1 == *.svg ]]; then
	echo "converting $1 to .pdf"
	convert-svg-to-pdf $1
    fi
}

get-file standard-model.svg http://upload.wikimedia.org/wikipedia/commons/4/4b/Standard_Model_of_Elementary_Particles_modified_version.svg