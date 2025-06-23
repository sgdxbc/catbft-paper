SHELL=/bin/bash

LATEX := ./bin/latexrun
PAPER := paper
PDF := $(PAPER).pdf
ifneq (,$(wildcard suppl.pdf))
	PDF := $(PDF) suppl.pdf
endif

TEX := $(shell find ./ -type f -name "*.tex")
CLS := $(shell find ./ -type f -name "*.cls" -o -name "*.sty")
BIB := $(shell find ./ -type f -name "*.bib")
FIG := $(shell find ./figures ./graphs -type f -name "*.pdf" -o -name "*.png")

PAPER_DEPS := $(TEX) $(CLS) $(BIB) $(FIG)

.PHONY: all clean

all: $(PDF)

$(PDF): $(PAPER_DEPS)
	$(LATEX) $(addsuffix .tex, $(basename $@)) -O .latex.out -o $@

clean:
	$(LATEX) --clean-all -O .latex.out
	@ rm -frv .latex.out $(PDF)

arxiv: arxiv.tar.gz

arxiv.tar.gz: $(PAPER).pdf
	rm -rf arxiv
	mkdir -p arxiv
	latexpand --empty-comments $(PAPER).tex > arxiv/paper.tex
	cp .latex.out/paper.bbl arxiv/
	cp paper.cls macros.tex usenix-2020-09.sty arxiv/
	mkdir -p arxiv/figures arxiv/graphs
	cp figures/*.pdf arxiv/figures/
	cp graphs/*.pdf arxiv/graphs/
	(cd arxiv && tar czf ../arxiv.tar.gz *)

