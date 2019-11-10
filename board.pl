:- use_module(library(random)).
:- use_module(library(system)).

clearScreen:-
        write('\16\.'),nl.

display_game(TAB, PLAYER, pvp):-
        repeat,
        printBoard(TAB),
        nl, write(' PLAYER '), write(PLAYER),write(' - '),
        write('Choose an option!'), nl,
        write('1. Put Piece on Board'), nl,
        write('2. Move Piece'), nl,
        read(Action),
        gameChoice(Action, TAB, PLAYER).

gameChoice(1, TAB, PLAYER):-
	placePiece(TAB, PLAYER).

placePiece(TAB,PLAYER):-
        write('Choose an option!'), nl,
        write('1. Queen'), nl,
        write('2. Bishop'), nl,
        write('3. Tower'), nl,
        write('4. Horse'), nl,
        write('5. Pawn'), nl,
        read(Action),
        translate(Action,PLAYER,TYPE),
	verifyPlace(TAB,{LINE,COL,TYPE,PLAYER}),
        putPiece(TYPE, TAB, PLAYER).


verifyPlace(TAB, {LINE, COL, TYPE, PLAYER}):-
	getPiecesI(TAB, PLIST),
	nonmember({_,_,TYPE, PLAYER},PLIST).

verifyPlace(TAB,{LINE,COL,TYPE,PLAYER}):-
	clearScreen, printBoard(TAB),
        nl, write('Invalid Option. Try again!'), nl,
        placePiece(TAB,PLAYER).

putPiece(TYPE, TAB, PLAYER):-
        write(' Select Row/Column to put in: '),
        read(LINE/COL),
        verifyMoveInsideBoard(LINE, COL),
        verifyNotPiece(TAB, {LINE, COL, TYPE, PLAYER}).

putPiece(TYPE, TAB, PLAYER):-
	clearScreen, printBoard(TAB),
        nl, write('Invalid Position. Try again!'), nl,
        putPiece(TYPE, TAB,PLAYER).

gameChoice(2, TAB, PLAYER):-
        choosePiece(TAB, PLAYER, SQUARE).

gameChoice(_, TAB, PLAYER):-
        write('Choose a valid option!').
        
choosePiece(TAB, PLAYER, SQUARE):-
        write(' Select Row/Column: '),
        read(LINE/COL),
        verifyPosition(TAB,LINE,COL,PLAYER,SQUARE).

verifyPosition(TAB,LINE,COL,PLAYER,SQUARE):-
        verifyMoveInsideBoard(LINE, COL),
        verifyPiece(TAB, {LINE, COL, TYPE, PLAYER}).

verifyPosition(TAB,LINE,COL,PLAYER,SQUARE):-
        clearScreen, printBoard(TAB),
        nl, write('Invalid Position. Try again!'), nl,
        choosePiece(TAB,PLAYER,SQUARE).

verifyPiece(TAB, {LINE, COL, TYPE, PLAYER}):-
	getPiecesI(TAB, PLIST),
	member({LINE,COL,TYPE, PLAYER},PLIST).

verifyNotPiece(TAB, {LINE, COL, TYPE, PLAYER}):-
	getPiecesI(TAB, PLIST),
	member({LINE,COL,none,none},PLIST).

board(
[
[{1,1,none,none}, {1,2,none,none}, {1,3,none,none}, {1,4,none,none}],
[{2,1,none,none}, {2,2,none,none}, {2,3,kingB,black}, {2,4,none,none}],
[{3,1,none,none}, {3,2,kingW,white}, {3,3,none,none}, {3,4,none,none}],
[{4,1,none,none}, {4,2,none,none}, {4,3,none,none}, {4,4,none,none}]
]
).

translate({_,_,none, none},S) :- S='  '.
translate({_,_,kingB, black},S) :- S='kB'.
translate({_,_,kingW, white},S) :- S='kW'.
translate({_,_,queenB, black},S) :- S='qB'.
translate({_,_,queenW, white},S) :- S='qW'.
translate({_,_,bishopB, black},S) :- S='bB'.
translate({_,_,bishopW, white},S) :- S='bW'.
translate({_,_,towerB, black},S) :- S='tB'.
translate({_,_,towerW, white},S) :- S='tW'.
translate({_,_,horseB, black},S) :- S='hB'.
translate({_,_,horseW, white},S) :- S='hW'.
translate({_,_,pawnB, black},S) :- S='pB'.
translate({_,_,pawnW, white},S) :- S='pW'.

translate(1, white, S):- S='queenW'.
translate(2, white, S):- S='bishopW'.
translate(3, white, S):- S='towerW'.
translate(4, white, S):- S='horseW'.
translate(5, white, S):- S='pawnW'.

translate(1, black, S):- S='queenB'.
translate(2, black, S):- S='towerB'.
translate(3, black, S):- S='pawnB'.
translate(4, black, S):- S='bishopB'.
translate(5, black, S):- S='horseB'.

printBoard(TAB):-
	printSeparatorIndex, nl,
	printSeparatorLine,
	board(TAB), nl,
        printMatrix(TAB, 1),
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

getPiecesI([],[]).

getPiecesI([H|T], PLIST):-
	getPiecesI(T, AUX1),
	getPiecesJ(H, AUX2),
	append(AUX1, AUX2, PLIST).

getPiecesJ([],[]).

getPiecesJ([H|T], PLIST):-
	getPiecesJ(T, AUX1),
	createList(H,  AUX2),
	append(AUX1, AUX2, PLIST).

createList({X,Y,Z,W},[{X,Y,Z,W}]).

/*General Movement*/
verifyMoveInsideBoard(LINE, COL):-
        LINE>=1,
        LINE=<4,
        COL>=1,
        COL=<4.

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
        board(TAB),
        display_game(TAB, white, pvp).

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

play:-
        printMainMenu,
        write(' Selecione uma opcao:'), nl,
        selectGameMode.
