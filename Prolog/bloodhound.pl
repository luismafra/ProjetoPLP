:- initialization(main).

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
    Resposta = r{lugar:Lugar,arma:Arma,pessoa:Pessoa}. 

criaBaralho(Resposta, Dados, Baralho):-
    remove(Resposta.lugar, Dados.lugares, [], Lugares),
    remove(Resposta.arma, Dados.armas, [], Armas),
    remove(Resposta.pessoa, Dados.pessoas, [], Pessoas),
    append(Lugares, Armas, Aux),
    append(Aux, Pessoas, Baralho).

sorteiaCartas(0,Baralho,Dados,Cartas,NovoBaralho,Pessoa) :-
    Pessoa = r{lugares:Dados.lugares,armas:Dados.armas,pessoas:Dados.pessoas,prioridades:["","",""],cartas:Cartas,cont:0},
    NovoBaralho = Baralho.

sorteiaCartas(I,Baralho,Dados,Cartas,NovoBaralho,Pessoa) :-   
    len(Baralho, R),
    random(0,R,X),
    nth0(X, Baralho, Carta),
    remove(Carta,Baralho,[],NovoArray),
    NewI is I - 1,
    (member(Carta,Dados.lugares) -> 
    remove(Carta,Dados.lugares,[],NovosLugares),
    append(Cartas,[Carta],NovasCartas),
    sorteiaCartas(NewI,NovoArray,Dados.put([lugares:NovosLugares]),NovasCartas,NovoBaralho,Pessoa)
    ;
    member(Carta,Dados.armas) -> 
    remove(Carta,Dados.armas,[],NovasArmas),
    append(Cartas,[Carta],NovasCartas),
    sorteiaCartas(NewI,NovoArray,Dados.put([armas:NovasArmas]),NovasCartas,NovoBaralho,Pessoa)
    ;
    remove(Carta,Dados.pessoas,[],NovasPessoas),
    append(Cartas,[Carta],NovasCartas),
    sorteiaCartas(NewI,NovoArray,Dados.put([pessoas:NovasPessoas]),NovasCartas,NovoBaralho,Pessoa)
    ).

mostraCartas(Pessoa) :-
    writeln(Pessoa.cartas).

mostraPossiveis(Pessoa) :-
    writeln("POSSIBILIDADES DE LUGARES PARA O JOGADOR:"),
    writeln(Pessoa.lugares),
    writeln("POSSIBILIDADES DE ARMAS PARA O JOGADOR:"),
    writeln(Pessoa.armas),
    writeln("POSSIBILIDADES DE PESSOAS PARA O JOGADOR:"),
    writeln(Pessoa.pessoas).

mostraMenu(Pessoa) :-
    writeln("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"),
    writeln("-=-=                          Sua vez de jogar ...                           =-=-"), 
    writeln("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"),
    writeln("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"),
    mostraPossiveis(Pessoa),
    writeln("Escolha uma opcao"),
    writeln("1 - Perguntar ao bot1"),
    writeln("2 - Perguntar ao bot2"),
    writeln("3 - Dar um palpite"),
    writeln("4 - Olhar suas cartas"),
    writeln("5 - Sair"),
    writeln("Opcao> ").

verificaResposta(Resposta,Palpite,Retorno) :-
    Resposta.lugar = Palpite.lugar,
    Resposta.arma = Palpite.arma,
    Resposta.pessoa = Palpite.pessoa,
    write("PARABENS, VOCE VENCEU O JOGO!, "),write(Palpite.pessoa),
    write(" matou com um(a) "),write(Palpite.arma),
    write(" no(a) "),writeln(Palpite.lugar), Retorno = true;
    Retorno = false.

realizaPalpite(Resposta,Dados,Retorno) :-
    getPalpiteLugar(Dados.lugares,PalpiteLugar),
    getPalpiteArma(Dados.armas,PalpiteArma),
    getPalpitePessoa(Dados.pessoas,PalpitePessoa),
    verificaResposta(Resposta,r{lugar:PalpiteLugar,arma:PalpiteArma,pessoa:PalpitePessoa},Retorno).

verificaCartas(Palpites,Cartas,BotPossui) :-
    exclude([X]>>(not(member(X,Palpites))), Cartas, BotPossui).

start(Pessoa,Bot1,Bot2,Resposta,Dados,"0") :-
    mostraMenu(Pessoa),
    read_line(Opcao),
    start(Pessoa,Bot1,Bot2,Resposta,Dados,Opcao).

start(Pessoa,Bot1,Bot2,Resposta,Dados,"1") :-
    vezDoJogador(Pessoa,Bot1,Dados,NovaPessoa),nl,
    start(NovaPessoa,Bot1,Bot2,Resposta,Dados,"0").


start(Pessoa,Bot1,Bot2,Resposta,Dados,"2") :-
    vezDoJogador(Pessoa,Bot2,Dados,NovaPessoa),nl,
    start(NovaPessoa,Bot1,Bot2,Resposta,Dados,"0").

start(Pessoa,Bot1,Bot2,Resposta,Dados,"3") :-
    realizaPalpite(Resposta,Dados,Retorno),nl,
    (Retorno -> start(Pessoa,Bot1,Bot2,Resposta,Dados,"5");
    start(Pessoa,Bot1,Bot2,Resposta,Dados,"0")
    ).

start(Pessoa,Bot1,Bot2,Resposta,Dados,"4") :-
    mostraCartas(Pessoa),nl,
    start(Pessoa,Bot1,Bot2,Resposta,Dados,"0").

start(_,_,_,_,_,"5") :-
    writeln("FIM DE JOGO").

start(Pessoa,Bot1,Bot2,Resposta,Dados,Opcao) :-
    writeln("Opcao invalida"),
    start(Pessoa,Bot1,Bot2,Resposta,Dados,"0").


main :-
    Lugares = ["Lavanderia", "Banco" , "Estadio", "Cinema", "Floresta", "Escola", "Igreja", "Shopping", "Praia"],
    Armas = ["Machado", "Pa", "Arma quimica", "Revolver", "Faca", "Pe de cabra", "Veneno", "Corda", "Tesoura"],
    Pessoas = ["Johann", "Matias", "Clarisse", "Alfred", "Jasmine", "Rosa", "Taylor", "Solomon", "Viktor"],
    Dados = r{lugares: Lugares,armas:Armas,pessoas:Pessoas},

    criaResposta(Dados,Resposta),
    criaBaralho(Resposta,Dados,Baralho),

    sorteiaCartas(8,Baralho,Dados,[],NovoBaralho,Pessoa),
    sorteiaCartas(8,NovoBaralho,Dados,[],OutroBaralho,Bot1),
    sorteiaCartas(8,OutroBaralho,Dados,[],BaralhoVazio,Bot2),
    
    start(Pessoa,Bot1,Bot2,Resposta,Dados,"0").    