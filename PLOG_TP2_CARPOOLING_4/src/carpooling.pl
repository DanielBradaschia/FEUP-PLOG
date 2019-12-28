/*nome | tem carro? (0,1) | deseja levar carro? (0,1) | grupo desejado (lista de nomes) | grupo indesejado (lista de nomes)*/

list(
[
[Danilo, 0, 0, [Antonio,Vinicius,Tiago], []],
[Livia, 1, 1, [Vitoria,Anna], [Danilo]],
[Vitoria, 1, 0, [Luiza], [Danilo,Nicolash]],
[Anna, 0, 0, [], [Danilo]],
[Larissa, 1, 1, [Danilo], []],
[Luiza, 1, 0, [Danilo], []],
[Antonio, 1, 1, [Danilo], []],
[Vinicius, 0, 0, [], []],
[Tiago, 0, 0, [Alex,Enzo], []],
[Luiz, 0, 0, [Danilo], []],
[Alice, 1, 1, [], []],
[Rafael, 0, 0, [Alice,Erick], [Nicolash]],
[Erick, 1, 0, [Alice,Rafael], []],
[Nicolash, 0, 0, [Júlia], []],
[Renan, 0, 0, [], []],
[Júlia, 0, 0, [Nicolash], []],
[Victor, 1, 1, [Diego], []],
[Diego, 0, 0, [Danilo,Victor], [Luiza]],
[Alex, 1, 1, [Tiago,Enzo], []],
[Enzo, 0, 0, [Alex,Tiago,Manuela], [Vitoria]],
[Manuela, 0, 0, [Laura], [Alex,Diego]],
[Laura, 0, 0, [Manuela], [Alex,Diego]]
]
).


/*Get nth element*/
match([H|_],0,H) :-
    !.
match([_|T],N,H) :-
    N > 0,
    N1 is N-1,
    match(T,N1,H).

getWanted([H|T], NUM, L):-
    match([H|T], NUM, [HR | TR]),
    getWantedLoop([H|T], HR, L).

getWantedLoop([], HR, L).

getWantedLoop([H|T], HR, L):-
    getWantedAux(HR, H, L, LAUX),
    getWantedLoop(T, HR, LAUX).

getWantedAux(HR, [H|T], L, LAUX):-
    match([H|T], 3, AUX),
    member(HR, AUX),
    append(L, [H], LAUX).

getWantedAux(HR, [H|T], L, LAUX):-
    match([H|T], 3, AUX),
    \+ member(HR, AUX).
