BIBTEX   = bibtex
PDFTEX = pdflatex -interaction=nonstopmode -halt-on-error -shell-escape

.PHONY: all

ALLSRC := $(wildcard *talk.tex)
all: $(ALLSRC:.tex=.pdf)
	@rm -f TMP-*

TEXFILES := $(shell find -L . -maxdepth 2 -name '*.tex')

%.bbl: %.tex $(TEXFILES) *.bib
	$(PDFTEX) $* --draftmode
	$(BIBTEX) $*

IGNORE_WARNINGS := 'Marginpar on page|float specifier changed'
COLOR_WARNINGS := '^LaTeX Warning:|Fatal error'
FILTER_WARN := egrep -v $(IGNORE_WARNINGS) | egrep --color $(COLOR_WARNINGS)
%.pdf: %.tex $(TEXFILES)
	$(PDFTEX) $< --draftmode
	$(PDFTEX) $<
