#!/usr/bin/env bash

set -eu

function curl-checked() {
    local BASE=$(basename $1)
    local OUT=${2-$BASE}

    local RM_IF_FAIL=0
    if [[ ! -f $OUT ]] ; then RM_IF_FAIL=1 ; fi

    local RET_CODE=$(curl -s $1 -o $OUT -w '%{http_code}')
    if [[ $RET_CODE != 200 ]]; then
	if [[ $RM_IF_FAIL ]] ; then
	    rm -f $OUT
	fi
	return 1
    fi
}

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

function convert-eps-to-pdf() {
    if ! hash epstopdf &> /dev/null ; then
	echo "epstopdf not found, quitting" 2>&1
	return 1
    fi
    local OUT=${1%.eps}.pdf
    if [[ $OUT -nt $1 ]] ; then
	echo "$OUT is newer than $1, not remaking"
	return 0
    fi
    if [[ $1 != *.eps ]] ; then
	echo "can't convert $1 with epstopdf" 2>&1
	return 1
    fi
    epstopdf --outfile=$OUT $1
}

function get-file() {
    local BASE=$(basename $1)
    local OUT=${2-$BASE}
    if [[ ${BASE##*.} != ${OUT##*.} ]]; then
	echo -n "extension mismatch between $BASE and $OUT, " 2>&1
	echo "(${BASE##*.} != ${OUT##*.}) quitting" 2>&1
	return 1
    fi
    if [[ -f $OUT ]]; then
	echo "already have $OUT"
    else
	echo -n "getting $OUT..."
	if ! curl-checked $1 $OUT ; then
	    echo "failed!" 2>&1
	    return 1
	fi
	echo "done"
    fi

    if [[ $OUT == *.svg ]]; then
	echo "converting $OUT to .pdf"
	convert-svg-to-pdf $OUT
    elif [[ $OUT == *.eps ]]; then
	echo "converting $OUT to .pdf"
	convert-eps-to-pdf $OUT
    fi

}

# graphs and schematics
get-file http://upload.wikimedia.org/wikipedia/commons/4/4b/Standard_Model_of_Elementary_Particles_modified_version.svg standard-model.svg
get-file http://atlas.web.cern.ch/Atlas/GROUPS/PHYSICS/CONFNOTES/ATLAS-CONF-2013-041/fig_06.pdf alpha-strong.pdf
get-file https://atlas.web.cern.ch/Atlas/GROUPS/PHYSICS/CombinedSummaryPlots/SM/ATLAS_b_SMSummary_FiducialXsect/ATLAS_b_SMSummary_FiducialXsect.pdf atlas-sm.pdf
get-file https://atlas.web.cern.ch/Atlas/GROUPS/PHYSICS/PAPERS/SUSY-2013-21/fig_09b.pdf c1c2-exclusion.pdf
get-file http://www.hep.ph.ic.ac.uk/~wstirlin/plots/crosssections2012HE_v4.pdf
get-file http://mstwpdf.hepforge.org/plots/mstw2008nlo68cl_allpdfs.eps mstw-proton.eps
get-file http://www.hep.ph.ic.ac.uk/~wstirlin/plots/lumi2012_abs_v1.pdf mstw-lumi.pdf
get-file http://upload.wikimedia.org/wikipedia/commons/8/88/Logistic-curve.svg logistic-curve.svg
get-file http://i2.cdn.turner.com/cnnnext/dam/assets/120622060142-hadron-collider-aerial-view-story-top.jpg cern-from-air.jpg
get-file http://mediastream.cern.ch/MediaArchive/Photo/Public/2008/0803015/0803015_01/0803015_01-A4-at-144-dpi.jpg atlas-cal.jpg
# get-file https://twiki.cern.ch/twiki/pub/AtlasPublic/EventDisplayStandAlone/zpileup_20vtx_sept2011.png pileup-vertices.png
# tagging
get-file https://atlas.web.cern.ch/Atlas/GROUPS/PHYSICS/CONFNOTES/ATLAS-CONF-2014-046/fig_03b.pdf dstar-pion-mass.pdf
get-file https://atlas.web.cern.ch/Atlas/GROUPS/PHYSICS/CONFNOTES/ATLAS-CONF-2012-040/fig_01a.pdf negative-tag-sv0.pdf
get-file https://atlas.web.cern.ch/Atlas/GROUPS/PHYSICS/CONFNOTES/ATLAS-CONF-2014-004/fig_01a.pdf giacinto-mll.pdf
# tagging SF --- NOTE: duplicates of the ones in JFC note
get-file https://atlas.web.cern.ch/Atlas/GROUPS/PHYSICS/PUBNOTES/ATL-PHYS-PUB-2015-001/fig_05a.pdf sf-ctag-c-medium.pdf
get-file https://atlas.web.cern.ch/Atlas/GROUPS/PHYSICS/PUBNOTES/ATL-PHYS-PUB-2015-001/fig_05b.pdf sf-ctag-b-medium.pdf
get-file https://atlas.web.cern.ch/Atlas/GROUPS/PHYSICS/PUBNOTES/ATL-PHYS-PUB-2015-001/fig_06a.pdf sf-ctag-u-medium.pdf

# cosmology things
get-file http://apod.nasa.gov/apod/image/0608/bulletcluster_comp_f2048.jpg
get-file http://sci.esa.int/science-e-media/img/61/Planck_CMB_Mollweide_wallpaper.jpg

# ugly graphs
get-file http://www.nobelprize.org/nobel_prizes/physics/laureates/2004/phypub4highen.jpg unification-ugly.jpg
get-file http://ufldl.stanford.edu/wiki/images/0/0e/Stacked_SparseAE_Features1.png autoencoder-layer.png

# on pantheon
# feynman
PAN=http://pantheon.yale.edu/~dhg3
get-file $PAN/feyn/scsc-ccN1N1.pdf feyn-sctoc.pdf
get-file $PAN/feyn/stst-ccN1N1-bWC1loop.pdf feyn-sttoc.pdf
get-file $PAN/feyn/stst-ccN1N1-bWC1loop-ISR.pdf feyn-sttoc-isr.pdf
# tagging
get-file $PAN/tagging/plots/ctag-2d-gaia-vs-jfc.pdf
get-file $PAN/tagging/plots/ctag-2d-jfc-vs-jfit.pdf
get-file $PAN/tagging/plots/ctag-2d-jfc-vs-mv.pdf
get-file $PAN/tagging/plots/ctag-2d-gaia-vs-mv.pdf
get-file $PAN/tagging/plots/uRejRoc.pdf
get-file $PAN/tagging/plots/cRejRoc.pdf
get-file $PAN/tagging/plots/uRej70_ptbins.pdf
get-file $PAN/tagging/plots/cRej70_ptbins.pdf
get-file $PAN/tagging/plots/rejrej-simple.pdf
get-file $PAN/tagging/plots/rejrej-btag.pdf
get-file $PAN/tagging/plots/rejrej-cprob.pdf
# other
get-file $PAN/misc-fig/blocked-stop-lsp.pdf
# get-file $PAN/misc-fig/atlas.tif
get-file $PAN/misc-fig/atlas-medium.jpeg
get-file $PAN/misc-fig/pileup-vertices.png

# on github
GHGRAPH=https://raw.githubusercontent.com/dguest/tagging-diagrams/master/
# GHGRAPH=https://github.com/dguest/tagging-diagrams/blob/master
get-file $GHGRAPH/sm-detectable.svg
get-file $GHGRAPH/b-jet.svg
get-file $GHGRAPH/b-jet-ip.svg
get-file $GHGRAPH/b-jet-sv.svg
get-file $GHGRAPH/b-jet-jf.svg
get-file $GHGRAPH/sm-b-decay.svg
get-file $GHGRAPH/sm-t-decay.svg
