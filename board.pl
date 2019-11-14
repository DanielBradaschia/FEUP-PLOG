:- use_module(library(random)).
:- use_module(library(system)).

clearScreen:-
        write('\16\.'),nl.

display_game(TAB, PLAYER, win):-
	printBoard(TAB),
	nl , print(PLAYER), 
	write(' : WIN'),
        play.

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
        

display_game(TAB, PLAYER, cvc):-
        (	
		sleep(1),

		isTowerOnBoard(PLAYER, TAB)
                ->
                        repeat,
                        printBoard(TAB),
                        
                        nl, write(' PLAYER '), write(PLAYER),write(' - '),
                	random(1,4,Action),
                        gameChoice(Action, TAB, PLAYER, pvp)
                ;
                repeat,
		printBoard(TAB),
                nl, write(' PLAYER '), write(PLAYER),nl,

                random(1,3,Action),
                gameChoice(Action, TAB, PLAYER, cvc)
        ).

gameChoice(1, TAB, PLAYER, STATE):-
	placePiece(TAB, PLAYER, NEWTAB, STATE),
	game_over(NEWTAB, WIN, PLAYER, STATE).

gameChoice(2, TAB, PLAYER, STATE):-
        choosePiece(TAB, {LINE, COL, TYPE, PLAYER}, STATE),
        movePiece(TAB, {LINE, COL, TYPE, PLAYER}, NEWTAB, STATE),
	game_over(NEWTAB, WIN, PLAYER, STATE).

gameChoice(3, TAB, PLAYER, STATE):-
        getTowerPos({TL,TC, tower,PLAYER}, TAB),
        getKingPos({KL,KC, king,PLAYER}, TAB),
        replace(TAB, TL, TC, {TL, TC, king, PLAYER}, NEWTAB),
        replace(NEWTAB, KL, KC, {KL, KC, tower, PLAYER}, NEWTAB2),
        display_game(NEWTAB2, PLAYER, STATE).


placePiece(TAB, PLAYER, NEWTAB, pvp):-
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
	verifyPlace(TAB,{LINE,COL,TYPE,PLAYER}, pvp),
        putPiece(TYPE, TAB, PLAYER, NEWTAB, pvp).

placePiece(TAB, PLAYER, NEWTAB, cvc):-
        random(1,6, Action),
        translate(Action,PLAYER,TYPE),
	verifyPlace(TAB,{LINE,COL,TYPE,PLAYER}, cvc),
        putPiece(TYPE, TAB, PLAYER, NEWTAB, cvc).

verifyPlace(TAB, {LINE, COL, TYPE, PLAYER}, _):-
	getPiecesI(TAB, PLIST),
	nonmember({_,_,TYPE, PLAYER},PLIST).

verifyPlace(TAB,{LINE,COL,TYPE,PLAYER}, pvp):-
	clearScreen, printBoard(TAB),
        nl, write('Invalid Option. Try again!'), nl,
        placePiece(TAB,PLAYER,NEWTAB, pvp).

verifyPlace(TAB,{LINE,COL,TYPE,PLAYER}, cvc):-
	placePiece(TAB,PLAYER,NEWTAB, cvc).

putPiece(TYPE, TAB, PLAYER, NEWTAB, pvp):-
        write(' Select Place (Row/Column) to put in: '),
        read(LINE/COL),
        verifyMoveInsideBoard(LINE, COL),
        verifyNotPiece(TAB, {LINE, COL, TYPE, PLAYER}),
        verifyKingDist(TAB, {LINE, COL, TYPE, PLAYER}),
        replace(TAB, LINE, COL, {LINE, COL, TYPE, PLAYER}, NEWTAB).

putPiece(TYPE, TAB, PLAYER, NEWTAB, pvp):-
	clearScreen, printBoard(TAB),
        nl, write('Invalid Position. Try again!'), nl,
        putPiece(TYPE, TAB, PLAYER, NEWTAB, pvp).

putPiece(TYPE, TAB, PLAYER, NEWTAB, cvc):-
        random(1,5, LINE),
        random(1,5, COL),
        verifyMoveInsideBoard(LINE, COL),
        verifyNotPiece(TAB, {LINE, COL, TYPE, PLAYER}),
        verifyKingDist(TAB, {LINE, COL, TYPE, PLAYER}),
        replace(TAB, LINE, COL, {LINE, COL, TYPE, PLAYER}, NEWTAB),
	nl, write('Computer Placed : '),
	print(TYPE),
	write(' at '),
	print(LINE),
	write('/'),
	print(COL), nl, nl.

putPiece(TYPE, TAB, PLAYER, NEWTAB, cvc):-
        putPiece(TYPE, TAB, PLAYER, NEWTAB, cvc).
        
choosePiece(TAB, {LINE, COL, TYPE, PLAYER}, pvp):-
        write(' Select Piece (Row/Column): '),
        read(LINE/COL),
        verifyPosition(TAB, {LINE, COL, TYPE, PLAYER}).

choosePiece(TAB, {LINE, COL, TYPE, PLAYER}, pvp):-
        clearScreen, printBoard(TAB),
        nl, write('Invalid Position. Try again!'), nl,
        choosePiece(TAB, {LINE, COL, TYPE, PLAYER}, pvp).

choosePiece(TAB, {LINE, COL, TYPE, black}, cvc):-
        random(1,5, LINE),
        random(1,5, COL),        
        verifyPosition(TAB, {LINE, COL, TYPE, PLAYER}).

choosePiece(TAB, {LINE, COL, TYPE, black}, cvc):-
        choosePiece(TAB, {LINE, COL, TYPE, PLAYER}, cvc).

verifyPosition(TAB, {LINE, COL, TYPE, PLAYER}):-
        verifyMoveInsideBoard(LINE, COL),
        verifyPiece(TAB, {LINE, COL, TYPE, PLAYER}).

verifyPiece(TAB, {LINE, COL, TYPE, PLAYER}):-
	getPiecesI(TAB, PLIST),
	member({LINE,COL,TYPE, PLAYER},PLIST).

verifyNotPiece(TAB, {LINE, COL, TYPE, PLAYER}):-
	getPiecesI(TAB, PLIST),
	member({LINE,COL,none,none},PLIST).

movePiece(TAB, {LINE, COL, TYPE, PLAYER}, NEWTAB, pvp):-
        write(' Select Destination (Row/Column) or 0/0 to Return: '),
        read(LINEEND/COLEND),
        verifyEndPosition(TAB,LINEEND,COLEND,{LINE, COL, TYPE, PLAYER},NEWTAB).

movePiece(TAB, {LINE, COL, TYPE, PLAYER}, NEWTAB, cvc):-
        random(1,5, LINEEND),
        random(1,5, COLEND),      
        verifyEndPosition(TAB,LINEEND,COLEND,{LINE, COL, TYPE, PLAYER},NEWTAB),
	nl ,write('Computer Moved : '),
	print(TYPE),
	write(' to '),
	print(LINEEND),
	write('/'),
	print(COLEND), nl, nl.

verifyEndPosition(TAB,LINEEND,COLEND,{LINE, COL, TYPE, PLAYER},NEWTAB):-
        verifyMoveInsideBoard(LINEEND, COLEND),
        verifyNotPiece(TAB, {LINEEND, COLEND, TYPE, PLAYER}),
        verifyMove({LINE, COL, TYPE, PLAYER}, {LINEEND,COLEND}),
        executeMove({LINE, COL, TYPE, PLAYER}, {LINEEND,COLEND}, TAB, NEWTAB).

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

replace(TAB, L, C, {LINE, COL, TYPE, PLAYER}, NEWTAB) :-
        I is L-1,
        J is C-1,
        append(RowPfx,[Row|RowSfx],TAB),    
        length(RowPfx,I),                 
        append(ColPfx,[_|ColSfx],Row),    
        length(ColPfx,J),                 
        append(ColPfx,[{LINE, COL, TYPE, PLAYER}|ColSfx],RowNew), 
        append(RowPfx,[RowNew|RowSfx],NEWTAB).

isTowerOnBoard(PLAYER, TAB):-
        memberlists({_,_, tower,PLAYER}, TAB).        

memberlists(X, Xss):-
        member(Xs, Xss),
        member(X, Xs).

getTowerPos({PL,PC, tower,PLAYER}, Xss) :-
   member(Xs, Xss),
   member({PL,PC,tower,PLAYER}, Xs).

verifyKingDist(TAB, {LINE, COL, TYPE, white}):-
        getKingPos({PL,PC,king,black}, TAB),
        AUXLINE is abs(LINE-PL),
        AUXCOL is abs(COL-PC),
        AUX is AUXLINE+AUXCOL,
        AUX>=2.

verifyKingDist(TAB, {LINE, COL, TYPE, black}):-
        getKingPos({PL,PC,king,white}, TAB),
        AUXLINE is abs(LINE-PL),
        AUXCOL is abs(COL-PC),
        AUX is AUXLINE+AUXCOL,
        AUX>=2.

game_over(TAB, WIN, PLAYER, STATE):-
        getKingPos({PL,PC,king,white}, TAB),
        FRONT is PL-1,
        \+verifyVictory(TAB,FRONT,PC,{PL, PC, king,white},NEWTAB),
        BACK is PL+1,
        \+verifyVictory(TAB,BACK,PC,{PL, PC, king,white},NEWTAB),
        RIGHT is PC+1,
        \+verifyVictory(TAB,PL,RIGHT,{PL, PC, king,white},NEWTAB),
        LEFT is PC-1,
        \+verifyVictory(TAB,PL,LEFT,{PL, PC, king,white},NEWTAB),
	display_game(TAB, black, win).

game_over(TAB, WIN, PLAYER, STATE):-
        getKingPos({PL,PC,king,black}, TAB),
        FRONT is PL-1,
        \+verifyVictory(TAB,FRONT,PC,{PL,PC,king,black},NEWTAB),
        BACK is PL+1,
        \+verifyVictory(TAB,BACK,PC,{PL,PC,king,black},NEWTAB),
        RIGHT is PC+1,
        \+verifyVictory(TAB,PL,RIGHT,{PL,PC,king,black},NEWTAB),
        LEFT is PC-1,
        \+verifyVictory(TAB,PL,LEFT,{PL,PC,king,black},NEWTAB),
	display_game(TAB, white, win).

game_over(TAB, WIN, black, pvp):-
	display_game(TAB, white, pvp).

game_over(TAB, WIN, white, pvp):-
	display_game(TAB, black, pvp).

game_over(TAB, WIN, black, cvc):-
	display_game(TAB, white, cvc).

game_over(TAB, WIN, white, cvc):-
	display_game(TAB, black, cvc).


getKingPos({PL,PC,king,PLAYER}, Xss) :-
   member(Xs, Xss),
   member({PL,PC,king,PLAYER}, Xs).

verifyVictory(TAB,LINEEND,COLEND,{LINE, COL, TYPE, PLAYER},NEWTAB):-
        verifyMoveInsideBoard(LINEEND, COLEND),
        verifyNotPiece(TAB, {LINEEND, COLEND, TYPE, PLAYER}),
        verifyMove({LINE, COL, TYPE, PLAYER}, {LINEEND,COLEND}).

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
verifyMoveType({LINE,COL,king},{LINE_END,COL_END}):-
        verifyMoveKing(LINE, COL, LINE_END, COL_END).

verifyMoveType({LINE,COL,queen},{LINE_END,COL_END}):-
        verifyMoveQueen(LINE, COL, LINE_END, COL_END).

verifyMoveType({LINE,COL,tower},{LINE_END,COL_END}):-
        verifyMoveTower(LINE, COL, LINE_END, COL_END).

verifyMoveType({LINE,COL,bishop},{LINE_END,COL_END}):-
        verifyMoveBishop(LINE, COL, LINE_END, COL_END).

verifyMoveType({LINE,COL,horse},{LINE_END,COL_END}):-
        verifyMoveHorse(LINE, COL, LINE_END, COL_END).

verifyMoveType({LINE,COL,pawn},{LINE_END,COL_END}):-
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

board(
[
[{1,1,none,none}, {1,2,none,none}, {1,3,none,none}, {1,4,none,none}],
[{2,1,none,none}, {2,2,none,none}, {2,3,king,black}, {2,4,none,none}],
[{3,1,none,none}, {3,2,king,white}, {3,3,none,none}, {3,4,none,none}],
[{4,1,none,none}, {4,2,none,none}, {4,3,none,none}, {4,4,none,none}]
]
).

translate({_,_,none, none},S) :- S='  '.
translate({_,_,king, black},S) :- S='kB'.
translate({_,_,king, white},S) :- S='kW'.
translate({_,_,queen, black},S) :- S='qB'.
translate({_,_,queen, white},S) :- S='qW'.
translate({_,_,bishop, black},S) :- S='bB'.
translate({_,_,bishop, white},S) :- S='bW'.
translate({_,_,tower, black},S) :- S='tB'.
translate({_,_,tower, white},S) :- S='tW'.
translate({_,_,horse, black},S) :- S='hB'.
translate({_,_,horse, white},S) :- S='hW'.
translate({_,_,pawn, black},S) :- S='pB'.
translate({_,_,pawn, white},S) :- S='pW'.

translate(1, white, S):- S='queen'.
translate(2, white, S):- S='bishop'.
translate(3, white, S):- S='tower'.
translate(4, white, S):- S='horse'.
translate(5, white, S):- S='pawn'.

translate(1, black, S):- S='queen'.
translate(2, black, S):- S='bishop'.
translate(3, black, S):- S='tower'.
translate(4, black, S):- S='horse'.
translate(5, black, S):- S='pawn'.


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
