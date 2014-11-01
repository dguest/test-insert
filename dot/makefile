# graphviz generation 
DOT_DIR   := .
DOT_FILES := $(wildcard $(DOT_DIR)/*.dot)
DOT_PDF   := $(DOT_FILES:%.dot=%.pdf)
testpdflatex: $(DOT_PDF)

$(DOT_DIR)/%.pdf: $(DOT_DIR)/%.dot
	@echo making $@ from $^
	@dot -Tps2 $^ | ps2pdf - - > $@
