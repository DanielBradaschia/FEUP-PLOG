:- use_module(library(random)).
:- use_module(library(system)).

clearScreen:-
        write('\16\.'),nl.

display_game(TAB, PLAYER, win):-
	printBoard(TAB),
	nl , print(PLAYER), 
	write(' : WIN'),
        play.

display_game(TAB, PLAYER, cvc):-
        (
                
                isTowerOnBoard(PLAYER, TAB)
                ->
                        repeat,
                        printBoard(TAB),
                        
                        nl, write(' PLAYER '), write(PLAYER),nl,
                        random(1,4,Action),
                        gameChoice(Action, TAB, PLAYER, cvc)
                ;
                repeat,
                printBoard(TAB),
                
                nl, write(' PLAYER '), write(PLAYER),nl,
                random(1,3,Action),
                gameChoice(Action, TAB, PLAYER, cvc)
        ).

gameChoice(1, TAB, black, cvc):-
        placePieceAuto(TAB, black, NEWTAB),
        game_over(NEWTAB, WIN, black, cvc).

gameChoice(1, TAB, white, cvc):-
        placePieceAuto(TAB, white, NEWTAB),
        game_over(NEWTAB, WIN, white, cvc).


placePieceAuto(TAB, PLAYER, NEWTAB):-
        random(1,7, Action),
        translate(Action,PLAYER,TYPE),
	verifyPlaceAuto(TAB,{LINE,COL,TYPE,PLAYER}),
        putPieceAuto(TYPE, TAB, PLAYER, NEWTAB).

verifyPlaceAuto(TAB, {LINE, COL, TYPE, PLAYER}):-
	getPiecesI(TAB, PLIST),
	nonmember({_,_,TYPE, PLAYER},PLIST).

verifyPlaceAuto(TAB,{LINE,COL,TYPE,PLAYER}):-
	placePieceAuto(TAB,PLAYER,NEWTAB).

putPieceAuto(TYPE, TAB, PLAYER, NEWTAB):-
        random(1,5, LINE),
        random(1,5, COL),
        verifyMoveInsideBoard(LINE, COL),
        verifyNotPiece(TAB, {LINE, COL, TYPE, PLAYER}),
        verifyKingDist(TAB, {LINE, COL, TYPE, PLAYER}),
        replace(TAB, LINE, COL, {LINE, COL, TYPE, PLAYER}, NEWTAB).

putPieceAuto(TYPE, TAB, PLAYER, NEWTAB):-
        putPieceAuto(TYPE, TAB, PLAYER, NEWTAB).

gameChoice(2, TAB, black, cvc):-
        choosePieceAuto(TAB, {LINE, COL, TYPE, black}),
        movePieceAuto(TAB, {LINE, COL, TYPE, PLAYER}, NEWTAB),
	game_over(NEWTAB, WIN, black, cvc).

choosePieceAuto(TAB, {LINE, COL, TYPE, black}):-
        random(1,5, LINE),
        random(1,5, COL),        
        verifyPosition(TAB, {LINE, COL, TYPE, PLAYER}).

choosePieceAuto(TAB, {LINE, COL, TYPE, black}):-
        choosePieceAuto(TAB, {LINE, COL, TYPE, PLAYER}).

movePieceAuto(TAB, {LINE, COL, TYPE, PLAYER}, NEWTAB):-
        random(1,5, LINEEND),
        random(1,5, COLEND),        
        verifyEndPosition(TAB,LINEEND,COLEND,{LINE, COL, TYPE, PLAYER},NEWTAB).

gameChoice(3, TAB, white, cvc):-
        getWhiteTowerPos({TL,TC, towerW,white}, TAB),
        getWhiteKingPos({KL,KC, kingW,white}, TAB),
        replace(TAB, TL, TC, {TL, TC, kingW, white}, NEWTAB),
        replace(NEWTAB, KL, KC, {KL, KC, towerW, white}, NEWTAB2),
        display_game(NEWTAB2, black, cvc).

gameChoice(3, TAB, black, cvc):-
        getBlackTowerPos({TL,TC, towerB,black}, TAB),
        getBlackKingPos({KL,KC, kingB,black}, TAB),
        replace(TAB, TL, TC, {TL, TC, kingB, black}, NEWTAB),
        replace(NEWTAB, KL, KC, {KL, KC, towerB, black}, NEWTAB2),
        display_game(NEWTAB2, white, cvc).



display_game(TAB, PLAYER, pvp):-
        (
                
                isTowerOnBoard(PLAYER, TAB)
                ->
                        repeat,
                        printBoard(TAB),
                        
                        nl, write(' PLAYER '), write(PLAYER),write(' - '),
                        write('Choose an option!'), nl,
                        write('1. Put Piece on Board'), nl,
                        write('2. Move Piece'), nl,
                        write('3. Swap Tower and King'), nl,
                        read(Action),
                        Action > 0,
                        Action < 4,
                        gameChoice(Action, TAB, PLAYER, pvp)
                ;
                repeat,
                printBoard(TAB),
                
                nl, write(' PLAYER '), write(PLAYER),write(' - '),
                write('Choose an option!'), nl,
                write('1. Put Piece on Board'), nl,
                write('2. Move Piece'), nl,
                read(Action),
                Action > 0,
                Action < 3,
                gameChoice(Action, TAB, PLAYER, pvp)
        ).
        

gameChoice(3, TAB, white, pvp):-
        getWhiteTowerPos({TL,TC, towerW,white}, TAB),
        getWhiteKingPos({KL,KC, kingW,white}, TAB),
        replace(TAB, TL, TC, {TL, TC, kingW, white}, NEWTAB),
        replace(NEWTAB, KL, KC, {KL, KC, towerW, white}, NEWTAB2),
        display_game(NEWTAB2, black, pvp).

gameChoice(3, TAB, black, pvp):-
        getBlackTowerPos({TL,TC, towerB,black}, TAB),
        getBlackKingPos({KL,KC, kingB,black}, TAB),
        replace(TAB, TL, TC, {TL, TC, kingB, black}, NEWTAB),
        replace(NEWTAB, KL, KC, {KL, KC, towerB, black}, NEWTAB2),
        display_game(NEWTAB2, white, pvp).

isTowerOnBoard(white, TAB):-
        memberlists({_,_, towerW,white}, TAB).        

isTowerOnBoard(black, TAB):-
        memberlists({_,_, towerB,black}, TAB).

memberlists(X, Xss):-
        member(Xs, Xss),
        member(X, Xs).

getWhiteTowerPos({PL,PC, towerW,white}, Xss) :-
   member(Xs, Xss),
   member({PL,PC,towerW,white}, Xs).

getBlackTowerPos({PL,PC,towerB,black}, Xss) :-
   member(Xs, Xss),
   member({PL,PC,towerB,black}, Xs).


gameChoice(1, TAB, black, pvp):-
	placePiece(TAB, black, NEWTAB),
	game_over(NEWTAB, WIN, black, pvp).

gameChoice(1, TAB, white, pvp):-
	placePiece(TAB, white, NEWTAB),
	game_over(NEWTAB, WIN, white, pvp).

placePiece(TAB, PLAYER, NEWTAB):-
        write('Choose an option!'), nl,
        write('1. Queen'), nl,
        write('2. Bishop'), nl,
        write('3. Tower'), nl,
        write('4. Horse'), nl,
        write('5. Pawn'), nl,
        write('6. Return'), nl,
        read(Action),
        Action > 0,
        Action < 7,
        Action =:= 6 -> display_game(TAB, PLAYER, pvp);
        translate(Action,PLAYER,TYPE),
	verifyPlace(TAB,{LINE,COL,TYPE,PLAYER}),
        putPiece(TYPE, TAB, PLAYER, NEWTAB).

/*Ve peca repetida*/
verifyPlace(TAB, {LINE, COL, TYPE, PLAYER}):-
	getPiecesI(TAB, PLIST),
	nonmember({_,_,TYPE, PLAYER},PLIST).

verifyPlace(TAB,{LINE,COL,TYPE,PLAYER}):-
	clearScreen, printBoard(TAB),
        nl, write('Invalid Option. Try again!'), nl,
        placePiece(TAB,PLAYER,NEWTAB).

putPiece(TYPE, TAB, PLAYER, NEWTAB):-
        write(' Select Place (Row/Column) to put in: '),
        read(LINE/COL),
        verifyMoveInsideBoard(LINE, COL),
        verifyNotPiece(TAB, {LINE, COL, TYPE, PLAYER}),
        verifyKingDist(TAB, {LINE, COL, TYPE, PLAYER}),
        replace(TAB, LINE, COL, {LINE, COL, TYPE, PLAYER}, NEWTAB).

putPiece(TYPE, TAB, PLAYER, NEWTAB):-
	clearScreen, printBoard(TAB),
        nl, write('Invalid Position. Try again!'), nl,
        putPiece(TYPE, TAB, PLAYER, NEWTAB).

gameChoice(2, TAB, black, pvp):-
        choosePiece(TAB, {LINE, COL, TYPE, black}),
        movePiece(TAB, {LINE, COL, TYPE, PLAYER}, NEWTAB),
	game_over(NEWTAB, WIN, black, pvp).

gameChoice(2, TAB, white, pvp):-
        choosePiece(TAB, {LINE, COL, TYPE, white}),
        movePiece(TAB, {LINE, COL, TYPE, PLAYER}, NEWTAB),
	game_over(NEWTAB, WIN, white, pvp).

verifyKingDist(TAB, {LINE, COL, TYPE, white}):-
        getBlackKingPos({PL,PC,kingB,black}, TAB),
        AUXLINE is abs(LINE-PL),
        AUXCOL is abs(COL-PC),
        AUX is AUXLINE+AUXCOL,
        AUX>=2.

verifyKingDist(TAB, {LINE, COL, TYPE, black}):-
        getWhiteKingPos({PL,PC,kingW,white}, TAB),
        AUXLINE is abs(LINE-PL),
        AUXCOL is abs(COL-PC),
        AUX is AUXLINE+AUXCOL,
        AUX>=2.

game_over(TAB, WIN, PLAYER, STATE):-
        getWhiteKingPos({PL,PC,kingW,white}, TAB),
        FRONT is PL-1,
        \+verifyVictory(TAB,FRONT,PC,{PL, PC, kingW,white},NEWTAB),
        BACK is PL+1,
        \+verifyVictory(TAB,BACK,PC,{PL, PC, kingW,white},NEWTAB),
        RIGHT is PC+1,
        \+verifyVictory(TAB,PL,RIGHT,{PL, PC, kingW,white},NEWTAB),
        LEFT is PC-1,
        \+verifyVictory(TAB,PL,LEFT,{PL, PC, kingW,white},NEWTAB),
	display_game(TAB, black, win).

game_over(TAB, WIN, PLAYER, STATE):-
        getBlackKingPos({PL,PC,kingB,black}, TAB),
        FRONT is PL-1,
        \+verifyVictory(TAB,FRONT,PC,{PL,PC,kingB,black},NEWTAB),
        BACK is PL+1,
        \+verifyVictory(TAB,BACK,PC,{PL,PC,kingB,black},NEWTAB),
        RIGHT is PC+1,
        \+verifyVictory(TAB,PL,RIGHT,{PL,PC,kingB,black},NEWTAB),
        LEFT is PC-1,
        \+verifyVictory(TAB,PL,LEFT,{PL,PC,kingB,black},NEWTAB),
	display_game(TAB, white, win).

game_over(TAB, WIN, black, pvp):-
	display_game(TAB, white, pvp).

game_over(TAB, WIN, white, pvp):-
	display_game(TAB, black, pvp).

game_over(TAB, WIN, black, cvc):-
	display_game(TAB, white, cvc).

game_over(TAB, WIN, white, cvc):-
	display_game(TAB, black, cvc).


getWhiteKingPos({PL,PC,kingW,white}, Xss) :-
   member(Xs, Xss),
   member({PL,PC,kingW,white}, Xs).

getBlackKingPos({PL,PC,kingB,black}, Xss) :-
   member(Xs, Xss),
   member({PL,PC,kingB,black}, Xs).

movePiece(TAB, {LINE, COL, TYPE, PLAYER}, NEWTAB):-
        write(' Select Destination (Row/Column) or 0/0 to Return: '),
        read(LINEEND/COLEND),
        verifyEndPosition(TAB,LINEEND,COLEND,{LINE, COL, TYPE, PLAYER},NEWTAB).

verifyEndPosition(TAB,LINEEND,COLEND,{LINE, COL, TYPE, PLAYER},NEWTAB):-
        verifyMoveInsideBoard(LINEEND, COLEND),
        verifyNotPiece(TAB, {LINEEND, COLEND, TYPE, PLAYER}),
        verifyMove({LINE, COL, TYPE, PLAYER}, {LINEEND,COLEND}),
        executeMove({LINE, COL, TYPE, PLAYER}, {LINEEND,COLEND}, TAB, NEWTAB).

verifyVictory(TAB,LINEEND,COLEND,{LINE, COL, TYPE, PLAYER},NEWTAB):-
        verifyMoveInsideBoard(LINEEND, COLEND),
        verifyNotPiece(TAB, {LINEEND, COLEND, TYPE, PLAYER}),
        verifyMove({LINE, COL, TYPE, PLAYER}, {LINEEND,COLEND}).

executeMove({LINE, COL, TYPE, PLAYER}, {LINEEND,COLEND}, TAB, NEWTAB):-
        moveAux({LINE, COL, TYPE, PLAYER}, {LINEEND,COLEND}, TAB, NEWTAB2),
        erasePiece({LINE, COL, TYPE, PLAYER}, NEWTAB2, NEWTAB).

moveAux(_,_,[],[]).

moveAux({LINE, COL, TYPE, PLAYER}, {LINEEND, COLEND}, [H|T], NEWTAB):-
	moveAux({LINE, COL, TYPE, PLAYER}, {LINEEND, COLEND}, T, NEWTAB2),
	moveAuxRec({LINE, COL, TYPE, PLAYER}, {LINEEND, COLEND}, H, NEWTAB3),
	append([NEWTAB3], NEWTAB2, NEWTAB).

moveAuxRec(_,_,[],[]).

moveAuxRec({LINE, COL, TYPE, PLAYER}, {LINEEND, COLEND}, [H|T], NEWTAB):-
	moveAuxRec({LINE, COL, TYPE, PLAYER}, {LINEEND, COLEND}, T, NEWTAB2),
	moveAuxSet({LINE, COL, TYPE, PLAYER}, {LINEEND, COLEND}, H, NEWPIECE),
	append([NEWPIECE], NEWTAB2, NEWTAB).

moveAuxSet({LINE, COL, TYPE, PLAYER}, {LINEEND, COLEND}, {LPOS, CPOS, none, none} , {LPOS, CPOS, TYPE, PLAYER}):-
	LPOS=LINEEND,
	CPOS=COLEND.

moveAuxSet(_,_,H,H).	

erasePiece(_,[],[]).

erasePiece({LINE, COL, TYPE, PLAYER}, [H|T], NEWTAB):-
        erasePiece({LINE, COL, TYPE, PLAYER}, T, NEWTAB2),
        erasePieceRec({LINE, COL, TYPE, PLAYER}, H, NEWTAB3),
        append([NEWTAB3], NEWTAB2, NEWTAB).


erasePieceRec(_, [], []).

erasePieceRec({LINE, COL, TYPE, PLAYER}, [H|T], NEWTAB):-
        erasePieceRec({LINE, COL, TYPE, PLAYER}, T, NEWTAB2),
        erasePieceSet({LINE, COL, TYPE, PLAYER}, H, NEWPIECE),
        append([NEWPIECE], NEWTAB2, NEWTAB).

erasePieceSet({LINE, COL, TYPE, PLAYER}, {LPOS, CPOS, TYPE, PLAYER},{LPOS,CPOS,none,none}):-
        LPOS=LINE,
        CPOS=COL.

erasePieceSet(_, H, H).


gameChoice(_, TAB, PLAYER, pvp):-
        write('Choose a valid option!').
        
choosePiece(TAB, {LINE, COL, TYPE, PLAYER}):-
        write(' Select Piece (Row/Column): '),
        read(LINE/COL),
        verifyPosition(TAB, {LINE, COL, TYPE, PLAYER}).

choosePiece(TAB, {LINE, COL, TYPE, PLAYER}):-
        clearScreen, printBoard(TAB),
        nl, write('Invalid Position. Try again!'), nl,
        choosePiece(TAB, {LINE, COL, TYPE, PLAYER}).

verifyPosition(TAB, {LINE, COL, TYPE, PLAYER}):-
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

replace(TAB, L, C, {LINE, COL, TYPE, PLAYER}, NEWTAB) :-
        I is L-1,
        J is C-1,
        append(RowPfx,[Row|RowSfx],TAB),    
        length(RowPfx,I),                 
        append(ColPfx,[_|ColSfx],Row),    
        length(ColPfx,J),                 
        append(ColPfx,[{LINE, COL, TYPE, PLAYER}|ColSfx],RowNew), 
        append(RowPfx,[RowNew|RowSfx],NEWTAB).

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
translate(2, black, S):- S='bishopB'.
translate(3, black, S):- S='towerB'.
translate(4, black, S):- S='horseB'.
translate(5, black, S):- S='pawnB'.

printBoard(TAB):-
	printSeparatorIndex, nl,
	printSeparatorLINE, nl,
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
        AX is abs(COL-COL_END),
        AY is LINE-LINE_END,
        validatePawnVertHor(AX,AY).

verifyMovePawn(LINE, COL, LINE_END, COL_END):-
        verifyMoveDiag(LINE, COL, LINE_END, COL_END),
        AX is abs(COL-COL_END),
        AY is LINE-LINE_END,
        validatePawnDiag(AX,AY).

validatePawnVertHor(AX,AY):-AX=0,AY=1.

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
        board(TAB),
        display_game(TAB, white, cvc).

gameMode(4):-
        nl, nl, nl,
        write(' _______________________________________________________ '), nl,
        write(' |                                                     | '), nl,
        write(' |                    HOW TO PLAY                      | '), nl,
        write(' |                                                     | '), nl,
        write(' |     Objective:                                      | '), nl,
        write(' |        Surround the cardinal points of              | '), nl,
        write(' |        the enemy king, while protecting             | '), nl,
        write(' |        your own!!!                                  | '), nl,
        write(' |                                                     | '), nl,
        write(' |                                                     | '), nl,
        write(' |     Rules:                                          | '), nl,
        write(' |        Select the options as they are presented,    | '), nl,
        write(' |        each piece has the traditional movement      | '), nl,
        write(' |        of chess, however under special              | '), nl,
        write(' |        circumstances a new option might appear!     | '), nl,
        write(' |                                                     | '), nl,
        write(' |_____________________________________________________| '), nl,
        play.

gameMode(5):-
        write(' |-----------------------------------------------------| '), nl,
        write(' |      Thank you so much for playing our game!        | '), nl,
        write(' |-----------------------------------------------------| '), nl,
        nl,
        nl.

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
