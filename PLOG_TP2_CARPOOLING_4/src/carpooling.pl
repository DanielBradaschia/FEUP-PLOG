:-use_module(library(clpfd)).

/*nome | tem carro? (0,1) | deseja levar carro? (0,1) | grupo desejado (id) | grupo indesejado (id)*/
list(
[
[1,        0, 0, 1, 2],
[2,        1, 1, 2, 3],
[3,        1, 0, 3, 4],
[4,        0, 0, 4, 5],
[5,        1, 1, 5, 1],
[6,        1, 0, 1, 2],
[7,        1, 1, 1, 2],
[8,        0, 0, 3, 4],
[9,        0, 0, 2, 3],
[10,       0, 0, 4, 5],
[11,       1, 1, 4, 1],
[12,       0, 0, 2, 3],
[13,       1, 0, 2, 3],
[14,       0, 0, 3, 4],
[15,       0, 0, 1, 2],
[16,       0, 0, 4, 5],
[17,       1, 1, 3, 4],
[18,       0, 0, 5, 1],
[19,       1, 1, 2, 3],
[20,       0, 0, 3, 4],
[21,       0, 0, 4, 5],
[22,       0, 0, 1, 2]
]
).

carpooling(L):-
    list(X),
    solve(X,N,L), !,
    print(N).

solve(INPUT,NUMBER,OUTPUT):-
    length(INPUT, NAUX),
    NUMBER is ceiling(NAUX/5),
    getDrivers(INPUT,NUMBER,DL),
    length(DL,I2),
    (I2 #= N ->
        addWanted(INPUT,DL,OUTPUT)
    ;
        N2 is N-I2,
        getDriversExtra(INPUT,N2,DL1),
        append(DL,DL1,DLF),
        addWanted(INPUT,DLF,OUTPUT)
    ).

/*adiciona wanteds de cada driver*/
addWanted(_,[],_).

addWanted(X,[H|T],L):-
    getWantedGroup(X,H,G),
    getWantedIds(X,G,W),
    write([H|T]),nl,
    nonmember(W, [H|T]),
    append([H],W,CAR),
    all_distinct(CAR),
    addWanted(X,T,LAUX),
    append(LAUX,[CAR],L).

/*getWanted Ids*/
getWantedIds([],_,_).

getWantedIds([H|T], G, L):-
    getWantedIds(T,G,LAUX),
    match(H,3,N),
    checkId(H,N,G,I),
    append(LAUX,I,L).

checkId(H,G,G,[I]):-
    match(H,0,I).

checkId(_,_,_,[]).

/*getWanted Group*/
getWantedGroup([],_,_).

getWantedGroup([H|T], G, L):-
    match(H,0,N),
    checkGroup(H,N,G,L),
    getWantedGroup(T,G,L).

checkGroup(H,G,G,L):- 
    match(H,3,L).

checkGroup(_,_,_,_).

/*pessoas que querem levar o carro*/
getDrivers([],_,_).

getDrivers(_,0,_).

getDrivers([H|T],N,DL):-
    match(H, 1, AUX1),
    match(H, 2, AUX2),
    match(H, 0, AUX3),
    checkDriver(N,N2,AUX3,AUX1,AUX2,D),
    getDrivers(T,N2,DAUX),
    append(DAUX,D,DL).

checkDriver(N,N2,AUX3,1,1,[AUX3]):-
    N2 is N-1,
    write('Driver : '),
    write(AUX3),nl.

checkDriver(N,N2,_,_,_,[]):-
    N2 is N.

/*pessoas que não querem levar o carro, mas tem*/
getDriversExtra([],_,_).

getDriversExtra(_,0,_).

getDriversExtra([H|T],N,DL):-
    match(H, 1, AUX1),
    match(H, 2, AUX2),
    match(H, 0, AUX3),
    checkDriverExtra(N,N2,AUX3,AUX1,AUX2,D),
    getDriversExtra(T,N2,DAUX),
    append(DAUX,D,DL).

checkDriverExtra(N,N2,AUX3,1,0,[AUX3]):-
    N2 is N-1,
    write('Driver : '),
    write(AUX3),nl.

checkDriverExtra(N,N2,_,_,_,[]):-
    N2 is N.

/*Get nth element*/
match([H|_],0,H).

match([_|T],N,H) :-
    N > 0,
    N1 is N-1,
    match(T,N1,H).
