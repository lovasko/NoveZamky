# Sudoku Solver
Sudoku `M*N` solver written in Prolog. Puzzles solved by this program are
always of a square size, with possibility of internal blocks having rectangle
size. Therefore a `3*4` sudoku will result in a `12*12` puzzle divided into 4
blocks horizontally and 3 blocks vertically. Numbers contained range from 1 to
12. The solver always yields all puzzle solutions. It is also possible to
verify a solution by querying the solver with already filled puzzle.

## Build
```
$ make
```

## Input
The solver expects the input file containing the puzzle to be in a specific
format:

First line of the file must contain `width` and `height` of the sudoku with a
dot (`.`) following each number. Both numbers must be unsigned integers. As
mentioned in the initial paragraph, they merely denote the size of the
*internal sudoku block* and not the whole sudoku size.

Example:
```
2. 3.
```

Following the size declaration, a matrix of actual puzzle numbers, each
followed by a dot, is expected.
In case of an unsolved field, `0` should take its place. Numbers in fields have
to be from the interval `1..N*M`.

Example:
```
0. 1. 0. 0. 0. 0.
2. 0. 0. 0. 0. 0.
0. 0. 0. 4. 0. 0.
0. 0. 3. 0. 0. 0.
0. 0. 0. 0. 5. 0.
0. 0. 0. 0. 0. 6.
```

## Algorithms
There are two basic approaches used in this program. First, the static solving
algorithm, which creates a list of fields at first, and than backtracks thought
this list, always inserting correct values to the puzzle. During the first
computation, no actual data modification is made and the heuristic method does
not take the values to account.

On the other hand, dynamic solving algorithm modifies actual puzzle data during
its run. The heuristic method is based on field values.  Common code shared
between these algorithms include sudoku puzzle `get`/`set` API calls and
predicates concerning field correctness.

### Static algorithms
The algorithm can be divided into two steps. First step is creating list of
fields that were not pre-solved. Order of fields in this list based on
heuristic approach.

Each individual technique is described in its subsection. Second step is using
Prolog’s internal back-tracking engine to try to fill in each field, element by
element.

#### Relatives
This heuristic approach sorts fields by following criterion: more fields in
same column, row or area already solved or added to list. These all are called
the *relatives*. In each step, it chooses the one with the most relatives.

#### Neighbours
This heuristic approach sorts fields by following criterion: more fields solved
or added to list from adjacent fields. These all are called the *neighbours*.
In each step, it chooses the one with the most neighbours.

### Adhoc (Dynamic Algorithm)
In each step of this algorithm, all yet unsolved fields are evaluated by
heuristic - fields with less possible correct values are ranked higher - and
than filled in. No list is being created, the actual puzzle is modified, so
each step needs to recalculate the heuristic values.

## Run
```
$ nz sudoku_file algorithm 
```

Where `sudoku_file` is a path to the puzzle and `algorithm` is one of the
previously mentioned techniques:
 * `relatives`
 * `neighbours`
 * `adhoc`

## Testing
The software package employs a different solving solution provided by 3rd party
written in C, that is located in the FreeBSD ports tree. This provides a
unbiased testing method by using a different codebase. In order to run the
tests, run the following commands:
```
$ cd test
$ make
$ make generate
$ make solve
```
The imported solver has `libncruses` as a dependency.

## Prolog versions
The solver was successfully built, run and tested with following Prolog
flavours:
 * GNU Prolog

## Author
Daniel Lovasko lovasko@freebsd.org
