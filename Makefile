all: main.pl io.pl util.pl doc
	gplc --no-top-level main.pl

doc: doc/manual.tex
	pdflatex -output-directory doc doc/manual.tex

clean:
	rm -f main