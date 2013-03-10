all: main.pl io.pl util.pl
	gplc --no-top-level main.pl

clean:
	rm -f main