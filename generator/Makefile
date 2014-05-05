all: sudoku.c
	gcc -o sudoku sudoku.c -lcurses -DTEMPLATE=\"template\"

generate:
	@bash generate.sh

solve:
	@bash solve.sh

clean:
	rm sudoku
	rm -rf generated_puzzles/