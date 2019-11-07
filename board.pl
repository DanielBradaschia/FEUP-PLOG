board(
[
[{}, {}, {}, {}],
[{}, {}, {2,3,kingB}, {}],
[{}, {3,2,kingW}, {}, {}],
[{}, {}, {}, {}]
]
).

translate({},S) :- S='  '.
translate({A,B,kingB},S) :- S='kB'.
translate({A,B,kingW},S) :- S='kW'.
translate({A,B,queenB},S) :- S='qB'.
translate({A,B,queenW},S) :- S='qW'.
translate({A,B,bishopB},S) :- S='bB'.
translate({A,B,bishopW},S) :- S='bW'.
translate({A,B,towerB},S) :- S='tB'.
translate({A,B,towerW},S) :- S='tW'.
translate({A,B,horseB},S) :- S='hB'.
translate({A,B,horseW},S) :- S='hW'.
translate({A,B,pawnB},S) :- S='pB'.
translate({A,B,pawnW},S) :- S='pW'.

display_game:-
	printSeparatorIndex, nl,
	printSeparatorLine,
	board(T), nl,
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

printSeparatorLine:-
        write('    ---------------------').

printSeparatorColumn:-
        write('|     |     |     |     |').

printSeparatorIndex:-
        write('      1    2    3    4 ').

getPieces(TAB, plist):-
	getPiecesI(TAB, plist).

getPiecesI([],[]).

getPiecesI([H|T], plist):-
	getPiecesI(T, aux1),
	getPiecesJ(H, aux2),
	append(aux1, aux2, plist).

getPiecesJ([H|T], plist):-
	getPiecesJ(T, aux1),
	createList(H,  aux2),
	append(aux1, aux2, plist).

createList({},[]).

createList({X,Y,Z,W},[{X,Y,Z,W}]).

verifyPlace(TAB, {line, col, type}):-
	getPieces(TAB, plist),
	nonmember({line,col,type},plist).


/*General Movement*/
verifyMoveInsideBoard(line, col):-
        line>=1,
        line=<4,
        col>=1,
        col=<4.

verifyMove({line,col,type},{line_end,col_end}):-
        line\=line_end,
        verifyMoveType({line,col,type},{line_end,col_end}).

verifyMove({line,col,type},{line_end,col_end}):-
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
verifyMoveType({line,col,kingW},{line_end,col_end}):-
        verifyMoveKing(line, col, line_end, col_end).

verifyMoveType({line,col,queenW},{line_end,col_end}):-
        verifyMoveQueen(line, col, line_end, col_end).

verifyMoveType({line,col,towerW},{line_end,col_end}):-
        verifyMoveTower(line, col, line_end, col_end).

verifyMoveType({line,col,bishopW},{line_end,col_end}):-
        verifyMoveBishop(line, col, line_end, col_end).

verifyMoveType({line,col,horseW},{line_end,col_end}):-
        verifyMoveHorse(line, col, line_end, col_end).

verifyMoveType({line,col,pawnB},{line_end,col_end}):-
        verifyMovePawn(line, col, line_end, col_end).

verifyMoveType({line,col,kingB},{line_end,col_end}):-
        verifyMoveKing(line, col, line_end, col_end).

verifyMoveType({line,col,queenB},{line_end,col_end}):-
        verifyMoveQueen(line, col, line_end, col_end).

verifyMoveType({line,col,towerB},{line_end,col_end}):-
        verifyMoveTower(line, col, line_end, col_end).

verifyMoveType({line,col,bishopB},{line_end,col_end}):-
        verifyMoveBishop(line, col, line_end, col_end).

verifyMoveType({line,col,horseB},{line_end,col_end}):-
        verifyMoveHorse(line, col, line_end, col_end).

verifyMoveType({line,col,pawnB},{line_end,col_end}):-
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


/*Game Functions*/
selectGameMode:-
        repeat,
        read(Action),
        Action > 0,
        Action < 6,
        gameMode(Action).

gameMode(1):-
        write('Em desenvolvimento').

gameMode(2):-
        write('Em desenvolvimento').

gameMode(3):-
        write('Em desenvolvimento').

gameMode(4):-
        write('Em desenvolvimento').

gameMode(5):-
        write(' |-----------------------------------------------------| '), nl,
        write(' |      Thank you so much for playing our game!        | '), nl,
        write(' |-----------------------------------------------------| '), nl,
        nl,
        nl.

gameMode(_):-
        write('Introduza uma opcao valida').

printMainMenu:-
        nl, nl, nl,
        write(' _______________________________________________________ '), nl,
        write(' |                                                     | '), nl,
        write(' |                 WELCOME TO ECHECK                   | '), nl,
        write(' |                                                     | '), nl,
        write(' |               Daniel Gazola Bradaschia              | '), nl,
        write(' |           Gustavo Speranzini Tosi Tavares           | '), nl,
        write(' |                 PLOG - FEUP 19/20                   | '), nl,
        write(' |                                                     | '), nl,
        write(' |-----------------------------------------------------| '), nl,
        write(' |                                                     | '), nl,
        write(' |         1. Start Game Player vs Player              | '), nl,
        write(' |         2. Start Game PC vs Player                  | '), nl,
        write(' |         3. Start Game PC vs PC                      | '), nl,
        write(' |         4. How to play                              | '), nl,
        write(' |         5. Exit                                     | '), nl,
        write(' |                   Choose an option                  | '), nl,
        write(' |_____________________________________________________| '), nl.

echeck:-
        printMainMenu,
        write(' Selecione uma opcao:'), nl,
        selectGameMode.


