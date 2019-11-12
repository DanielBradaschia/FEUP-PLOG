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

/*Ve peca repetida*/
verifyPlace(TAB, {LINE, COL, TYPE, PLAYER}):-
	getPiecesI(TAB, PLIST),
	nonmember({_,_,TYPE, PLAYER},PLIST).

verifyPlace(TAB,{LINE,COL,TYPE,PLAYER}):-
	clearScreen, printBoard(TAB),
        nl, write('Invalid Option. Try again!'), nl,
        placePiece(TAB,PLAYER).

putPiece(TYPE, TAB, PLAYER):-
        write(' Select Place (Row/Column) to put in: '),
        read(LINE/COL),
        verifyMoveInsideBoard(LINE, COL),
        verifyNotPiece(TAB, {LINE, COL, TYPE, PLAYER}).

putPiece(TYPE, TAB, PLAYER):-
	clearScreen, printBoard(TAB),
        nl, write('Invalid Position. Try again!'), nl,
        putPiece(TYPE, TAB,PLAYER).

gameChoice(2, TAB, PLAYER):-
        choosePiece(TAB, PLAYER, {LINE, COL, TYPE, PLAYER}),
        movePiece(TAB, PLAYER, {LINE, COL, TYPE, PLAYER}, WIN, NEWTAB).

movePiece(TAB, PLAYER, {LINE, COL, TYPE, PLAYER}, WIN, NEWTAB):-
        write(' Select Destination (Row/Column): '),
        read(LINEEND/COLEND),
        verifyEndPosition(TAB,LINEEND,COLEND,{LINE, COL, TYPE, PLAYER},WIN,NEWTAB).

verifyEndPosition(TAB,LINEEND,COLEND,{LINE, COL, TYPE, PLAYER},WIN,NEWTAB):-
        verifyMoveInsideBoard(LINEEND, COLEND),
        verifyNotPiece(TAB, {LINEEND, COLEND, TYPE, PLAYER}),
        verifyMove({LINE, COL, TYPE, PLAYER}, {LINEEND,COLEND}).
        /*executeMove({LINE, COL, TYPE, PLAYER}, {LINE,COL}, TAB, NEWTAB).*/

gameChoice(_, TAB, PLAYER):-
        write('Choose a valid option!').
        
choosePiece(TAB, PLAYER, {LINE, COL, TYPE, PLAYER}):-
        write(' Select Piece (Row/Column): '),
        read(LINE/COL),
        verifyPosition(TAB,LINE,COL,PLAYER,{LINE, COL, TYPE, PLAYER}).

choosePiece(TAB,PLAYER,{LINE, COL, TYPE, PLAYER}):-
        clearScreen, printBoard(TAB),
        nl, write('Invalid Position. Try again!'), nl,
        choosePiece(TAB,PLAYER,{LINE, COL, TYPE, PLAYER}).

verifyPosition(TAB,LINE,COL,PLAYER,{LINE, COL, TYPE, PLAYER}):-
        verifyMoveInsideBoard(LINE, COL),
        verifyPiece(TAB, {LINE, COL, TYPE, PLAYER}).

verifyPiece(TAB, {LINE, COL, TYPE, PLAYER}):-
	getPiecesI(TAB, PLIST),
	member({LINE,COL,TYPE, PLAYER},PLIST).

/*Ve espaco vazio*/
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
	printSeparatorLINE,
	board(TAB), nl,
        printMatrix(TAB, 1),
	printSeparatorLINE.
	

printMatrix([], 5).

printMatrix([H|T], N):-
        write('  '),
        N1 is N+1,
        write(N),
	write(' | '),
        printLINE(H),
	nl,
        printMatrix(T, N1).

printLINE([]).

printLINE([H|T]):-
        translate(H, S),
        write(S),
        write(' | '),
        printLINE(T).

printSeparatorLINE:-
        write('    ---------------------').

printSeparatorCOLumn:-
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

verifyMove({LINE,COL,TYPE,_},{LINE_END,COL_END}):-
        LINE\=LINE_END,
        verifyMoveType({LINE,COL,TYPE},{LINE_END,COL_END}).

verifyMove({LINE,COL,TYPE,_},{LINE_END,COL_END}):-
        COL\=COL_END,
        verifyMoveType({LINE,COL,TYPE},{LINE_END,COL_END}).

verifyMoveVertHor(LINE, COL, LINE_END, COL_END):-
        X is COL_END-COL,
        Y is LINE_END-LINE,
        validateMoveVertHor(X,Y).

validateMoveVertHor(X,Y):-
        X=0,Y\=0.
validateMoveVertHor(X,Y):-
        X\=0,Y=0.

verifyMoveDiag(LINE, COL, LINE_END, COL_END):-
        X is COL_END-COL,
        Y is LINE_END-LINE,
        AX is abs(X),
        AY is abs(Y),
        AX=AY.

/*Types of Movement*/
verifyMoveType({LINE,COL,kingW},{LINE_END,COL_END}):-
        verifyMoveKing(LINE, COL, LINE_END, COL_END).

verifyMoveType({LINE,COL,queenW},{LINE_END,COL_END}):-
        verifyMoveQueen(LINE, COL, LINE_END, COL_END).

verifyMoveType({LINE,COL,towerW},{LINE_END,COL_END}):-
        verifyMoveTower(LINE, COL, LINE_END, COL_END).

verifyMoveType({LINE,COL,bishopW},{LINE_END,COL_END}):-
        verifyMoveBishop(LINE, COL, LINE_END, COL_END).

verifyMoveType({LINE,COL,horseW},{LINE_END,COL_END}):-
        verifyMoveHorse(LINE, COL, LINE_END, COL_END).

verifyMoveType({LINE,COL,pawnW},{LINE_END,COL_END}):-
        verifyMovePawn(LINE, COL, LINE_END, COL_END).

verifyMoveType({LINE,COL,kingB},{LINE_END,COL_END}):-
        verifyMoveKing(LINE, COL, LINE_END, COL_END).

verifyMoveType({LINE,COL,queenB},{LINE_END,COL_END}):-
        verifyMoveQueen(LINE, COL, LINE_END, COL_END).

verifyMoveType({LINE,COL,towerB},{LINE_END,COL_END}):-
        verifyMoveTower(LINE, COL, LINE_END, COL_END).

verifyMoveType({LINE,COL,bishopB},{LINE_END,COL_END}):-
        verifyMoveBishop(LINE, COL, LINE_END, COL_END).

verifyMoveType({LINE,COL,horseB},{LINE_END,COL_END}):-
        verifyMoveHorse(LINE, COL, LINE_END, COL_END).

verifyMoveType({LINE,COL,pawnB},{LINE_END,COL_END}):-
        verifyMovePawn(LINE, COL, LINE_END, COL_END).

/*King Movement*/
verifyMoveKing(LINE, COL, LINE_END, COL_END):-
        verifyMoveVertHor(LINE, COL, LINE_END, COL_END),
        AX is abs(COL-COL_END),
        AY is abs(LINE-LINE_END),
        validateKingVertHor(AX,AY).

verifyMoveKing(LINE, COL, LINE_END, COL_END):-
        verifyMoveDiag(LINE, COL, LINE_END, COL_END),
        AX is abs(COL-COL_END),
        AY is abs(LINE-LINE_END),
        validateKingDiag(AX,AY).

validateKingVertHor(AX,AY):-AX=1,AY=0.

validateKingVertHor(AX,AY):-AX=0,AY=1.

validateKingDiag(AX,AX):-AX=1.

/*Queen Movement*/
verifyMoveQueen(LINE, COL, LINE_END, COL_END):-
        verifyMoveVertHor(LINE, COL, LINE_END, COL_END).

verifyMoveQueen(LINE, COL, LINE_END, COL_END):-
        verifyMoveDiag(LINE, COL, LINE_END, COL_END).

/*Tower Movement*/
verifyMoveTower(LINE, COL, LINE_END, COL_END):-
        verifyMoveVertHor(LINE, COL, LINE_END, COL_END).

/*Bishop Movement*/
verifyMoveBishop(LINE, COL, LINE_END, COL_END):-
        verifyMoveDiag(LINE, COL, LINE_END, COL_END).

/*Horse Movement*/
verifyMoveHorse(LINE, COL, LINE_END, COL_END):-
        AX is abs(COL-COL_END),
        AY is abs(LINE-LINE_END),
        validateMoveHorse(AX,AY).

validateMoveHorse(AX,AY):-AX=1,AY=2.

validateMoveHorse(AX,AY):-AX=2,AY=1.

/*Pawn Movement*/
verifyMovePawn(LINE, COL, LINE_END, COL_END):-
        verifyMoveVertHor(LINE, COL, LINE_END, COL_END),
        AX is COL_END-COL,
        AY is LINE_END-LINE,
        validatePawnVertHor(AX,AY).

verifyMovePawn(LINE, COL, LINE_END, COL_END):-
        verifyMoveDiag(LINE, COL, LINE_END, COL_END),
        AX is COL_END-COL,
        AY is LINE_END-LINE,
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
        write(' |         1. Start Player vs Player                   | '), nl,
        write(' |         2. Start PC vs Player                       | '), nl,
        write(' |         3. Start PC vs PC                           | '), nl,
        write(' |         4. How to play                              | '), nl,
        write(' |         5. Exit                                     | '), nl,
        write(' |                   Choose an option                  | '), nl,
        write(' |_____________________________________________________| '), nl.

play:-
        printMainMenu,
        write(' Selecione uma opcao:'), nl,
        selectGameMode.
