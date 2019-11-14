:- initialization(main).
:- use_module(library(http/json)).

ehLugar(Elem,Lista, R) :-
    (member(Elem, Lista)
    -> R = true
    ;  R = false).
ehArma(Elem,Lista, R) :-
    (member(Elem, Lista)
    -> R = true
    ;  R = false).
ehPessoa(Elem,Lista, R) :-
    (member(Elem, Lista)
    -> R = true
    ;  R = false).

lerJson(File) :-
    open("./dados.json", read, Teste),
    json_read_dict(Teste, File).

remove(_, [], Lista, Lista).
remove(Elem, [Elem | T], Lista, R):-
    append(Lista, T, R).
remove(Elem, [X | T], Lista, R):-
    append(Lista, [X], R2),
    remove(Elem, T, R2, R).

len([], R):-
    R is 0.

len([_|Y], R):-
    len(Y, L),
    R is L + 1.

criaResposta(R, Resposta) :-
    random(0,9,N),
    nth0(N,R.lugares,Lugar),
    random(0,9,X),
    nth0(X,R.armas,Arma),
    random(0,9,Y),
    nth0(Y,R.pessoas,Pessoa),
    Resposta = [Lugar, Arma, Pessoa]. 

criaBaralho(Resposta, Dados, Baralho):-
    nth0(0, Resposta, Lugar),
    remove(Lugar, Dados.lugares, [], Lugares),
    nth0(1, Resposta, Arma),
    remove(Arma, Dados.armas, [], Armas),
    nth0(2, Resposta, Pessoa),
    remove(Pessoa, Dados.pessoas, [], Pessoas),
    append(Lugares, Armas, Aux),
    append(Aux, Pessoas, Baralho).

player(Lugares,Armas,Pessoas,Retorno) :-
    Retorno = jogador(Lugares,Armas,Pessoas,["","",""],[],0).

sorteiaCartas(I,Baralho,Lugares,Armas,Pessoas,NovoBaralho,Cartas,Jogador) :-
    I =:= 0,
    Jogador = jogador(Lugares,Armas,Pessoas,["","",""],Cartas,0);  
    len(Baralho, R),
    random(0,R,X),
    nth0(X, Baralho, Carta),
    remove(Carta,Baralho,[],NovoBaralho),
    NewI is I - 1,
    member(Carta,Lugares) -> 
    remove(Carta,Lugares,[],NovosLugares),
    append(Cartas,[Carta],R),
    sorteiaCartas(NewI,NovoBaralho,NovosLugares,Armas,Pessoas,NovoBaralho,R,Jogador);
    member(Carta,Armas) -> 
    remove(Carta,Armas,[],NovasArmas),
    append(Cartas,[Carta],R),
    sorteiaCartas(NewI,NovoBaralho,Lugares,NovasArmas,Pessoas,NovoBaralho,R,Jogador);
    remove(Carta,Pessoas,[],NovasPessoas),
    append(Cartas,[Carta],R),
    sorteiaCartas(NewI,NovoBaralho,Lugares,Armas,NovasPessoas,NovoBaralho,R,Jogador).


main :-
    lerJson(File),
    nth0(0, File, Dados),
    player(Dados.lugares,Dados.armas,Dados.pessoas,Bot1),
    player(Dados.lugares,Dados.armas,Dados.pessoas,Bot2),
    player(Dados.lugares,Dados.armas,Dados.pessoas,Jogador),
    criaResposta(Dados,Resposta),
    criaBaralho(Resposta,Dados,Baralho),
    sorteiaCartas(8,Baralho,Dados.lugares,Dados.armas,Dados.pessoas,NovoBaralho,[],Jogador),
    Baralho = NovoBaralho,
    sorteiaCartas(8,Baralho,Dados.lugares,Dados.armas,Dados.pessoas,NovoBaralho,[],Bot1),
    Baralho = NovoBaralho,
    sorteiaCartas(8,Baralho,Dados.lugares,Dados.armas,Dados.pessoas,NovoBaralho,[],Bot2),
    Baralho = NovoBaralho,
    writeln(Resposta), writeln(Baralho).