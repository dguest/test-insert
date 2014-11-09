BIBTEX   = bibtex
PDFTEX = pdflatex -interaction=nonstopmode -halt-on-error -shell-escape

.PHONY: all

all: thesis.pdf

TEXFILES := $(shell find tex/ -name '*.tex')

%.bbl: %.tex $(TEXFILES) *.bib
	$(PDFTEX) $* --draftmode
	$(BIBTEX) $*

%.pdf: %.tex $(TEXFILES) %.bbl
	$(PDFTEX) $< --draftmode
	$(PDFTEX) $<
