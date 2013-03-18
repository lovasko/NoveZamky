#!/bin/bash

for sudoku in generated_puzzles/*
do
	./../main "$sudoku"
done