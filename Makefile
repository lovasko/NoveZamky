all: src/main.pl \
		 src/io.pl \
		 src/util.pl \
		 src/get_set.pl \
		 src/solve.pl \
		 src/listify.pl \
		 src/relatives.pl \
		 src/neighbours.pl \
		 doc
	gplc --no-top-level --output main src/main.pl

doc: doc/manual.tex
	pdflatex -output-directory doc doc/manual.tex

clean:
	rm -f main
	find doc/ -not -name '*tex' | xargs rm

