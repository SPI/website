
SRC=$(wildcard *.tex)
PDF=$(SRC:.tex=.pdf)

%.pdf: %.tex
	pdflatex $<
	pdflatex $<
	pdflatex $<

all: $(PDF)

clean:
	rm -f *.aux *.log *.out *.toc

