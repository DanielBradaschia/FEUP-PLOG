/*board(
display_board([
[empty, empty, empty, empty],
[empty, empty, kingB, empty],
[empty, kingW, empty, empty],
[empty, empty, empty, empty]
]
).
*/
translate(empty,S) :- S='  '.
translate(kingB,S) :- S='kB'.
translate(kingW,S) :- S='kW'.

display_board(X):-
        nl,
        printMatrix(X, 1).

printMatrix([], 4).

printMatrix([H|T], N):-
        write('  ');
        N1 is N+1,
        write(' | '),
        printLine(Head),
        printMatrix(T, N1).

printLine([]).

printLine([H|T]):-
        symbol(H, S),
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
