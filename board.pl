board(
[
[empty, empty, empty, empty],
[empty, empty, kingB, empty],
[empty, kingW, empty, empty],
[empty, empty, empty, empty]
]
).

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

