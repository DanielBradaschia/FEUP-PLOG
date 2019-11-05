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

display_game:-
	printSeparatorIndex, nl,
	printTop,
	board1(T), nl,
        printMatrix(T, 1),
	printSeparatorLine.
	

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
        write('     ___________________ ').

printSeparatorLine:-
        write('    |____|____|____|____|').

printSeparatorColumn:-
        write('|     |     |     |     |').

printSeparatorIndex:-
        write('      a    b    c    d ').


/*General Movement*/
verifyMoveInsideBoard(line, col):-
        line>=1,
        line=<4,
        col>=1,
        col=<4.

verifyMove({line,col,type,_},{line_end,col_end}):-
        line\=line_end,
        verifyMoveType({line,col,type},{line_end,col_end}).

verifyMove({line,col,type,_},{line_end,col_end}):-
        col\=col_end,
        verifyMoveType({line,col,type},{line_end,col_end}).

verifyMoveVertHor(line, col, line_end, col_end):-
        X is col_end-col,
        Y is line_end-line,
        validateMoveVertHor(X,Y).

validateMoveVertHor(X,Y):-
        X=0,Y\=0.
validateMoveVertHor(X,Y):-
        X\=0,Y=0.

verifyMoveDiag(line, col, line_end, col_end):-
        X is col_end-col,
        Y is line_end-line,
        AX is abs(X),
        AY is abs(Y),
        AX=AY.

/*Types of Movement*/
verifyMoveType({line,col,k},{line_end,col_end}):-
        verifyMoveKing(line, col, line_end, col_end).

verifyMoveType({line,col,q},{line_end,col_end}):-
        verifyMoveQueen(line, col, line_end, col_end).

verifyMoveType({line,col,t},{line_end,col_end}):-
        verifyMoveTower(line, col, line_end, col_end).

verifyMoveType({line,col,b},{line_end,col_end}):-
        verifyMoveBishop(line, col, line_end, col_end).

verifyMoveType({line,col,h},{line_end,col_end}):-
        verifyMoveHorse(line, col, line_end, col_end).

verifyMoveType({line,col,p},{line_end,col_end}):-
        verifyMovePawn(line, col, line_end, col_end).

/*King Movement*/
verifyMoveKing(line, col, line_end, col_end):-
        verifyMoveVertHor(line, col, line_end, col_end),
        AX is abs(col-col_end),
        AY is abs(line-line_end),
        validateKingVertHor(AX,AY).

verifyMoveKing(line, col, line_end, col_end):-
        verifyMoveDiag(line, col, line_end, col_end),
        AX is abs(col-col_end),
        AY is abs(line-line_end),
        validateKingDiag(AX,AY).

validateKingVertHor(AX,AY):-AX=1,AY=0.

validateKingVertHor(AX,AY):-AX=0,AY=1.

validateKingDiag(AX,AX):-AX=1.

/*Queen Movement*/
verifyMoveQueen(line, col, line_end, col_end):-
        verifyMoveVertHor(line, col, line_end, col_end).

verifyMoveQueen(line, col, line_end, col_end):-
        verifyMoveDiag(line, col, line_end, col_end).

/*Tower Movement*/
verifyMoveTower(line, col, line_end, col_end):-
        verifyMoveVertHor(line, col, line_end, col_end).

/*Bishop Movement*/
verifyMoveBishop(line, col, line_end, col_end):-
        verifyMoveDiag(line, col, line_end, col_end).

/*Horse Movement*/
verifyMoveHorse(line, col, line_end, col_end):-
        AX is abs(col-col_end),
        AY is abs(line-line_end),
        validateMoveHorse(AX,AY).

validateMoveHorse(AX,AY):-AX=1,AY=2.

validateMoveHorse(AX,AY):-AX=2,AY=1.

/*Pawn Movement*/
verifyMovePawn(line, col, line_end, col_end):-
        verifyMoveVertHor(line, col, line_end, col_end),
        AX is col_end-col,
        AY is line_end-line,
        validatePawnVertHor(AX,AY).

verifyMovePawn(line, col, line_end, col_end):-
        verifyMoveDiag(line, col, line_end, col_end),
        AX is col_end-col,
        AY is line_end-line,
        validatePawnDiag(AX,AY).

validatePawnVertHor(AX,AY):-AX=1,AY=0.

validatePawnDiag(AX,AX):-AX=1.


