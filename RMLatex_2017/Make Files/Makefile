
TEXINPUTS := ./sty:./tex

all: main.pdf

main.pdf: main.tex
	pdflatex --output-format=pdf main.tex 
	pdflatex --output-format=pdf main.tex 
	pdflatex --output-format=pdf main.tex 

clean: 
	rm -f main.pdf
	rm -f main.bib.info main.bib
	rm -f main.log main.lot main.dvi main.aux main.out main.toc main.lof
	rm -f *~ tex/*~ tex/*.aux


