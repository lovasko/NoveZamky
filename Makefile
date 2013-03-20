all: main.pl io.pl util.pl get_set.pl solve.pl listify.pl relatives.pl neighbours.pl doc
	gplc --no-top-level main.pl

doc: doc/manual.tex
	pdflatex -output-directory doc doc/manual.tex

clean:
	rm -f main
	find doc/ -not -name '*tex' | xargs rm