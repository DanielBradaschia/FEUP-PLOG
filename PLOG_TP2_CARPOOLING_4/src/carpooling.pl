/*nome | tem carro? (0,1) | deseja levar carro? (0,1) | grupo desejado (lista de nomes) | grupo indesejado (lista de nomes)*/

list(
[
['Danilo', 0, 0, ['Antonio','Vinicius','Tiago'], []],
['Livia', 1, 1, ['Vitoria','Anna'], ['Danilo']],
['Vitoria', 1, 0, ['Luiza'], ['Danilo','Nicolash']],
['Anna', 0, 0, [], ['Danilo']],
['Larissa', 1, 1, ['Danilo'], ['Luiz']],
['Luiza', 1, 0, ['Danilo'], []],
['Antonio', 1, 1, ['Danilo'], ['Livia']],
['Vinicius', 0, 0, [], []],
['Tiago', 0, 0, ['Alex','Enzo'], []],
['Luiz', 0, 0, ['Danilo','Renan''Larissa'], []],
['Alice', 1, 1, [], []],
['Rafael', 0, 0, ['Alice','Erick'], ['Nicolash']],
['Erick', 1, 0, ['Alice','Rafael'], []],
['Nicolash', 0, 0, ['Júlia'], []],
['Renan', 0, 0, [], []],
['Júlia', 0, 0, ['Nicolash'], []],
['Victor', 1, 1, ['Diego'], []],
['Diego', 0, 0, ['Danilo','Victor'], ['Luiza']],
['Alex', 1, 1, ['Tiago','Enzo'], []],
['Enzo', 0, 0, ['Alex','Tiago','Manuela'], ['Manuela']],
['Manuela', 0, 0, ['Laura'], ['Alex','Diego']],
['Laura', 0, 0, ['Manuela'], ['Alex','Diego']]
]
).

carpooling(L):-
    list(X),
    length(X,I),
    N is ceiling(I/5),
    write(N),
    write(' necessary cars'),nl,
    getDrivers(X,N,L),
    length(L,I2),
    N2 is N-I2,
    getDriversExtra(X,N2,L).

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

getWanted([H|T], NUM, L):-
    match([H|T], NUM, HR),
    match(HR,3,L).

getCar([], _).

getCar([H|T], L):-
    match(H, 1, AUX1),
    match(H, 2, AUX2),
    (AUX1 =:= 1 ->
        AUX2 =:= 1 ->
        match(H, 0, AUX3),
        append(L, [AUX3], LAUX),
        getCar(T, LAUX)
    ; getCar(T, L)
    ).