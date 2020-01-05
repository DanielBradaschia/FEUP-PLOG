:- use_module(library(clpfd)).
:- use_module(library(lists)).

/*nome | tem carro? (0,1) | deseja levar carro? (0,1) | grupo desejado (id) | grupo indesejado (id)*/
list(
[
{1,  0, 0, 1, 2},
{2,  1, 1, 2, 3},
{3,  1, 0, 3, 4},
{4,  0, 0, 4, 5},
{5,  1, 1, 5, 1},
{6,  1, 0, 1, 2},
{7,  1, 1, 1, 2},
{8,  0, 0, 3, 4},
{9,  0, 0, 2, 3},
{10, 0, 0, 4, 5},
{11, 1, 1, 4, 1},
{12, 0, 0, 2, 3},
{13, 1, 0, 2, 3},
{14, 0, 0, 3, 4},
{15, 0, 0, 1, 2},
{16, 0, 0, 4, 5},
{17, 1, 1, 3, 4},
{18, 0, 0, 5, 1},
{19, 1, 1, 2, 3},
{20, 0, 0, 3, 4},
{21, 0, 0, 4, 5},
{22, 0, 0, 1, 2}
]
).


carpooling(L):-
    list(X),
    solve(X,N,L), !,
    write('Total Cars: '),print(N),nl.

solve(INPUT,NUMBER,OUTPUT):-
    length(INPUT, NAUX),
    NUMBER is ceiling(NAUX/5),
    getDrivers(INPUT,NUMBER,OUTPUT1),
    write('Drivers: '),print(OUTPUT1),nl,
    length(OUTPUT1,N2),
    ( N2 #= NUMBER->
        addWanted(INPUT,OUTPUT1,OUTPUT4),
        addnoUnwanted(INPUT,OUTPUT4,OUTPUT)
    ;
        NE is NUMBER-N2,
        getDriversExtra(INPUT,NE,OUTPUT2),
        append(OUTPUT1,OUTPUT2,OUTPUT1),
        addWanted(INPUT,OUTPUT1,OUTPUT4),
        addnoUnwanted(INPUT,OUTPUT4,OUTPUT)
    ).

/*add rest*/
addRest(_,[],_).

addRest(X,[H|T],L):-
    length(H,C),
    C2 is 5-C,
    addPeopleRest(X,H,C2,W),
    append(H,W,CAR),
    addRest(X,T,LAUX),
    append(LAUX,[CAR],L).

addPeopleRest(_,_,0,[]).

addPeopleRest(X,[HS|_],C,CAR):-
    getUnwantedGroup(X,HS,UG),
    getUnwantedIds(X,UG,C,CAR).

/*add others in car*/
addnoUnwanted(_,[],_).

addnoUnwanted(X,[H|T],L):-
    length(H,C),
    C2 is 5-C,
    addPeople(X,H,C2,W),
    append(H,W,CAR),
    addnoUnwanted(X,T,LAUX),
    append(LAUX,[CAR],L).

addPeople(_,_,0,[]).

addPeople(X,[HS|_],C,CAR):-
    getUnwantedGroup(X,HS,UG),
    getWantedGroup(X,HS,WG),
    getNeutralIds(X,UG,WG,C,CAR).

/*add wanted people in car*/
addWanted(_,[],_).

addWanted(X,[H|T],L):-
    getWantedGroup(X,H,G),
    getWantedIds(X,G,W),
    makeCar(H,W,CAR),
    addWanted(X,T,LAUX),
    append(LAUX,[CAR],L).


/*add wanted people*/
addWanted(_,[],_).

addWanted(X,[H|T],L):-
    getWantedGroup(X,H,G),
    getWantedIds(X,G,W),
    makeCar(H,W,CAR),
    addWanted(X,T,LAUX),
    append(LAUX,[CAR],L).

/*create a car with no duplicates*/
makeCar(H,W,CAR):-
    member(H,W),
    deleteH(H,W,W2),
    append([H],W2,CAR).

makeCar(H,W,CAR):-
    append([H],W,CAR).

deleteH(_,[],_).

deleteH(H,[H|T],W):-
    deleteH(H,T,W).

deleteH(H,[HW|T],W):-
    deleteH(H,T,WAUX),
    append(WAUX,[HW],W).

/*getWanted Group*/
getWantedGroup([],_,_).

getWantedGroup([{ID,_,_,G,_}|_], ID, G).

getWantedGroup([_|T],ID,G):-
    getWantedGroup(T,ID,G).

/*getUnwanted Group*/
getUnwantedGroup([],_,_).

getUnwantedGroup([{ID,_,_,_,G}|_], ID, G).

getUnwantedGroup([_|T],ID,G):-
    getWantedGroup(T,ID,G).

/*getWanted Ids*/
getWantedIds([],_,_).

getWantedIds([{ID,_,_,G,_}|T], G, L):-
    getWantedIds(T,G,LAUX),
    append(LAUX,[ID],L).

getWantedIds([_|T], G, L):-
    getWantedIds(T,G,L).


/*getNeutral Ids*/
getNeutralIds(_,_,_,0,_).

getNeutralIds([],_,_,_,_).

getNeutralIds([{_,_,_,_,UG}|T], UG, WG, C, L):-
    getNeutralIds(T,UG,WG,C,L).

getNeutralIds([{_,_,_,WG,_}|T], UG, WG, C, L):-
    getNeutralIds(T,UG,WG,C,L).

getNeutralIds([{ID,_,_,_,_}|T], UG, WG, C, L):-
    C2 is C-1,
    getNeutralIds(T,UG,WG,C2,LAUX),
    append(LAUX,[ID],L).

/*getUnwanted Ids*/
getWantedIds([],_,_).

getWantedIds([{ID,_,_,_,G}|T], G, L):-
    getWantedIds(T,G,LAUX),
    append(LAUX,[ID],L).

getWantedIds([_|T], G, L):-
    getWantedIds(T,G,L).


/*get drivers who want to bring their car*/
getDrivers([],_,_).

getDrivers(_,0,_).

getDrivers([{H,1,1,_,_}|T],N,DL):-
    N2 is N-1,
    getDrivers(T,N2,DAUX),
    append(DAUX,[H],DL).

getDrivers([_|T],N,DL):-
    getDrivers(T,N,DL).


/*get extra drivers, those who don't want to bring their car*/
getDriversExtra([],_,_).

getDriversExtra(_,0,[]).

getDriversExtra([{H,1,0,_,_}|T],N,DL):-
    N2 is N-1,
    getDriversExtra(T,N2,DAUX),
    append(DAUX,[H],DL).

getDriversExtra([_|T],N,DL):-
    getDriversExtra(T,N,DL).