/*
display_game([
[empty, empty, empty, empty],
[empty, empty, kingB, empty],
[empty, kingW, empty, empty],
[empty, empty, empty, empty]
]).

display_game([
[queenB, empty, empty, kingB],
[empty, empty, empty, empty],
[empty, empty, bishopW, empty],
[empty, kingW, empty, empty]
]).

display_game([
[empty, empty, towerW, kingB],
[empty, empty, empty, bishopW],
[pawnB, empty, empty, empty],
[kingW, empty, empty, empty]
]).
*/

board1(
[
[empty, empty, empty, empty],
[empty, empty, kingB, empty],
[empty, kingW, empty, empty],
[empty, empty, empty, empty]
]
).

board2(
[
[queenB, empty, empty, kingB],
[empty, empty, empty, empty],
[empty, empty, bishopW, empty],
[empty, kingW, empty, empty]
]
).

board3(
[
[empty, empty, towerW, kingB],
[empty, empty, empty, bishopW],
[pawnB, empty, empty, empty],
[kingW, empty, empty, empty]
]
).

translate(empty,S) :- S='  '.
translate(kingB,S) :- S='kB'.
translate(kingW,S) :- S='kW'.
translate(queenB,S) :- S='qB'.
translate(queenW,S) :- S='qW'.
translate(bishopB,S) :- S='bB'.
translate(bishopW,S) :- S='bW'.
translate(towerB,S) :- S='tB'.
translate(towerW,S) :- S='tW'.
translate(horseB,S) :- S='hB'.
translate(horseW,S) :- S='hW'.
translate(pawnB,S) :- S='pB'.
translate(pawnW,S) :- S='pW'.

display_game(X):-
        nl,
        printMatrix(X, 1).

printMatrix([], 5).

printMatrix([H|T], N):-
        write('  '),
        N1 is N+1,
        write(N),
        write(' | '),
        printLine(H),
	nl,
        printMatrix(T, N1).

printLine([]).

printLine([H|T]):-
        translate(H, S),
        write(S),
        write(' | '),
        printLine(T).


printTop:-
        write('_________________________').

printSeparatorLine:-
        write('|_____|_____|_____|_____|').

printSeparatorColumn:-
        write('|     |     |     |     |').


printBoard:-
        printTop,nl,
        printSeparatorColumn,nl,
        printSeparatorLine,nl,
        printSeparatorColumn,nl,
        printSeparatorLine,nl,
        printSeparatorColumn,nl,
        printSeparatorLine,nl,
        printSeparatorColumn,nl,
        printSeparatorLine,nl.
