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

testeWanted(N,L):-
    list(X),
    getWanted(X,N,L).

testeCar(L):-
    list(X),
    getCar(X,L).

carpooling(L):-
    list(X),
    length(X,I),
    N is ceiling(I/5),
    write(N),
    write(' necessary cars'),nl,
    getDrivers(X,N,DL).

getDrivers(_,0,_).

getDrivers([H|T],N,DL):-
    match(H, 1, AUX1),
    match(H, 2, AUX2),
    match(H, 0, AUX3),
    checkDriver(N,AUX3,AUX1,AUX2,D,N2),
    getDrivers(T,N2,DL).

checkDriver(N,AUX3,1,1,AUX3,N2):-
    N2 is N-1,
    write('Driver : '),
    write(AUX3),nl.

checkDriver(N,_,_,_,[],N2):-
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

getCar([], L).

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