#!/bin/bash

mkdir -p generated_puzzles
prefix='generated_puzzles'

echo -n "[0/5]"
for i in `seq 5`
do
	echo -ne "\r[$i/5]"
	num="$RANDOM"
	./sudoku -g -fcompact > "$prefix/$num"_sudoku
	sed -i "" -e 's/\./0/g' "$prefix/$num"_sudoku 
	sed -i "" -e 's/\([0-9]\)/\1. /g' "$prefix/$num"_sudoku 
	sed -i "" -e '1s/.*/3. 3./' "$prefix/$num"_sudoku 
done
echo