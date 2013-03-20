all: main.pl io.pl util.pl
	gplc --no-top-level main.pl
	pdflatex -output-directory doc doc/manual.tex

clean:
	rm -f main