BIBTEX   = bibtex
PDFTEX = pdflatex -interaction=nonstopmode -halt-on-error -shell-escape

.PHONY: all

all: thesis.pdf
	@rm -f TMP-*

TEXFILES := $(shell find -L tex/ -maxdepth 2 -name '*.tex')
TEXFILES += $(shell find tables/ -name '*.tex')
TEXFILES += $(shell find . -maxdepth 1 -name '*.tex')

%.bbl: %.tex $(TEXFILES) *.bib
	$(PDFTEX) $* --draftmode
	$(BIBTEX) $*

IGNORE_WARNINGS := 'Marginpar on page|float specifier changed'
COLOR_WARNINGS := '^LaTeX Warning:|Fatal error'
FILTER_WARN := egrep -v $(IGNORE_WARNINGS) | egrep --color $(COLOR_WARNINGS)
%.pdf: %.tex $(TEXFILES) %.bbl
	$(PDFTEX) $< --draftmode
	$(PDFTEX) $< | $(FILTER_WARN)
