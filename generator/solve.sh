#!/bin/bash

for sudoku in generated_puzzles/*
do
	echo "Using method 'neighbours'"
	./../main "$sudoku" "neighbours"
	echo
	echo "Using method 'relatives'"
	./../main "$sudoku" "relatives"
	echo
done