:-use_module(library(clpfd)).

/*nome | tem carro? (0,1) | deseja levar carro? (0,1) | grupo desejado (id) | grupo indesejado (id)*/
list(
[
['Danilo',       0, 0, 1, 2],
['Livia',        1, 1, 2, 3],
['Vitoria',      1, 0, 3, 4],
['Anna',         0, 0, 4, 5],
['Larissa',      1, 1, 5, 1],
['Luiza',        1, 0, 1, 2],
['Antonio',      1, 1, 1, 2],
['Vinicius',     0, 0, 3, 4],
['Tiago',        0, 0, 2, 3],
['Luiz',         0, 0, 4, 5],
['Alice',        1, 1, 5, 1],
['Rafael',       0, 0, 2, 3],
['Erick',        1, 0, 2, 3],
['Nicolash',     0, 0, 3, 4],
['Renan',        0, 0, 1, 2],
['Julia',        0, 0, 4, 5],
['Victor',       1, 1, 3, 4],
['Diego',        0, 0, 5, 1],
['Alex',         1, 1, 2, 3],
['Enzo',         0, 0, 3, 4],
['Manuela',      0, 0, 4, 5],
['Laura',        0, 0, 1, 2]
]
).

testWanted(N,L):-
    list(X),
    length(X,I),
    write(I), nl,
    N #\= I,
    getWantedbyName(X, 'Enzo', L).

carpooling(L):-
    list(X),
    length(X,I),
    N is ceiling(I/5),
    write(N),
    write(' necessary cars'),nl,
    getDrivers(X,N,DL),
    write('Drivers List: '), write(DL), nl,
    length(DL,I2),
    (I2 #= N ->
        addWanted(X,DL,L)
    ;
        N2 is N-I2,
        getDriversExtra(X,N2,L),
        addWanted(X,DL,L)
    ).

/*adiciona wanteds de cada driver*/
addWanted(_,[],_).

addWanted(X,[H|T],L):-
    getWantedbyName(X,H,W),
    append([H],W,CAR),
    addWanted(X,T,LAUX),
    append(LAUX,[CAR],L).

/*getWanted pelo Nome*/
getWantedbyName([],_,_).

getWantedbyName([H|T], NAME, L):-
    match(H,0,N),
    checkName(H,N,NAME,L),
    getWantedbyName(T,NAME,L).

checkName(H,NAME,NAME,L):-
    match(H,3,L).

checkName(_,_,_,_).

checkName(H,NAME,NAME,L):-
    match(H,3,L).

checkName(_,_,_,_).

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
