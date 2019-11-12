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

main :-
    lerJson(File),
    nth0(0, File, Dados),
    criaResposta(Dados,Resposta),
    criaBaralho(Resposta,Dados,Baralho),
    writeln(Resposta), writeln(Baralho).