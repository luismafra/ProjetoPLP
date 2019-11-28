:- initialization(main).

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

read_line(String) :-
    current_input(Input),
    read_string(Input, "\n", "\r", End, String).

ajeitaPalavra(Palavra,Retorno) :-
    string_lower(Palavra, X),firstCharUppercase(X,Retorno).

firstCharUppercase(Palavra, Retorno) :-
    string_chars(Palavra, [First|Last]),
    atom_chars(PrimeiraLetra, [First]),
    upcase_atom(PrimeiraLetra, Uppercase),
    string_chars(Retorno, [Uppercase|Last]).

getPalpiteLugar(Lugares,PalpiteLugar) :-
    write("Digite o lugar: "),
    read_line(Palpite),
    ajeitaPalavra(Palpite,X),
    (member(X,Lugares) -> PalpiteLugar = X; writeln("Lugar inserido é invalido"),
    getPalpiteLugar(Lugares,PalpiteLugar)).

getPalpiteArma(Armas,PalpiteArma) :-
    write("Digite a arma: "),
    read_line(Palpite),
    ajeitaPalavra(Palpite,X),
    (member(X,Armas) -> PalpiteArma = X; writeln("Arma inserida é invalida"),
    getPalpiteArma(Armas,PalpiteArma)).

getPalpitePessoa(Pessoas,PalpitePessoa) :-
    write("Digite a pessoa: "),
    read_line(Palpite),
    ajeitaPalavra(Palpite,X),
    (member(X,Pessoas) -> PalpitePessoa = X; writeln("Pessoa inserida é invalida"),
    getPalpitePessoa(Pessoas,PalpitePessoa)).

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
    Retorno = true;
    Retorno = false.

realizaPalpite(Resposta,Dados,Retorno) :-
    getPalpiteLugar(Dados.lugares,PalpiteLugar),
    getPalpiteArma(Dados.armas,PalpiteArma),
    getPalpitePessoa(Dados.pessoas,PalpitePessoa),
    verificaResposta(Resposta,r{lugar:PalpiteLugar,arma:PalpiteArma,pessoa:PalpitePessoa},Retorno).

verificaCartas(Palpites,Cartas,BotPossui) :-
    exclude([X]>>(not(member(X,Palpites))), Cartas, BotPossui).

vezDoJogador(Pessoa,Bot,Dados,NovaPessoa) :-
    getPalpiteLugar(Dados.lugares,PalpiteLugar),
    getPalpiteArma(Dados.armas,PalpiteArma),
    getPalpitePessoa(Dados.pessoas,PalpitePessoa),
    verificaCartas([PalpiteLugar,PalpiteArma,PalpitePessoa],Bot.cartas,BotPossui),
    len(BotPossui,R),
    (R =:= 0 -> writeln("O bot nao possui nenhuma das 3 cartas"),NovaPessoa = Pessoa;
    random(0,R,X),
    nth0(X, BotPossui, Carta),
    write("O bot tinha "),writeln(Carta),
    (member(Carta,Pessoa.lugares) -> remove(Carta,Pessoa.lugares,[],NovosLugares),NovaPessoa = Pessoa.put([lugares:NovosLugares]);
    member(Carta,Pessoa.armas) -> remove(Carta,Pessoa.armas,[],NovasArmas),NovaPessoa = Pessoa.put([armas:NovasArmas]);
    remove(Carta,Pessoa.pessoas,[],NovasPessoas),NovaPessoa = Pessoa.put([pessoas:NovasPessoas])
    )
    ).

verificaCount(0,X) :- random(0,2,X).
verificaCount(1,1).
verificaCount(2,0).

getPalpiteLugarBot(Bot,PalpiteLugar) :-
    Bot.cont > 0, nth0(0,Bot.prioridades,PalpiteLugar);
    len(Bot.lugares, A),
    random(0, A, B),
    nth0(B, Bot.lugares, PalpiteLugar).

getPalpiteArmaBot(Bot,PalpiteArma) :-
    Bot.cont > 0, nth0(1,Bot.prioridades,PalpiteArma);
    len(Bot.armas, A),
    random(0, A, B),
    nth0(B, Bot.armas, PalpiteArma).

getPalpitePessoaBot(Bot,PalpitePessoa) :-
    Bot.cont > 0, nth0(2,Bot.prioridades,PalpitePessoa);
    len(Bot.pessoas, A),
    random(0, A, B),
    nth0(B, Bot.pessoas, PalpitePessoa).

jogadorResponde(Possiveis,Retorno) :-
    writeln("Você possui: "),writeln(Possiveis),
    write("Qual voce deseja que o bot saiba? "),
    read_line(X),ajeitaPalavra(X,Resposta),
    (member(Resposta,Possiveis) -> Retorno = Resposta;
    writeln("Essa nao é uma das opcoes"),jogadorResponde(Possiveis,Retorno)
    ).


vezDoBot(Nome,Pessoa,Bot1,Bot2,Resposta,NovoBot,Acabou) :-
    len(Bot1.pessoas,X),len(Bot1.armas,Y),len(Bot1.lugares,Z),
    Soma is X + Y + Z,Soma =:= 3,Acabou = true,NovoBot = Bot1; Bot1.cont =:= 3,Acabou = true,NovoBot = Bot1;
    random(0,10,Chance),
    (
        (Chance > 6,Bot1.cont > 0) -> nth0(0,Bot1.prioridades,PalpiteLugar),nth0(1,Bot1.prioridades,PalpiteArma),
        nth0(2,Bot1.prioridades, PalpitePessoa), verificaResposta(Resposta,r{lugar:PalpiteLugar,arma:PalpiteArma,pessoa:PalpitePessoa},Retorno),
        (Retorno -> Acabou = true, NovoBot = Bot1;
            writeln("O bot tentou chutar e errou"),NovoBot = Bot1.put([cont:0]),Acabou = false)
        ;

	verificaCount(Bot1.cont,Aux),
        getPalpiteLugarBot(Bot1,PalpiteLugar),
        getPalpiteArmaBot(Bot1,PalpiteArma),
        getPalpitePessoaBot(Bot1,PalpitePessoa),

        (
            Aux =:= 1 -> verificaCartas([PalpitePessoa, PalpiteLugar, PalpiteArma], Pessoa.cartas, Intercessao),
            writeln("A pergunta do bot para voce foi:"), 
            write("Lugar: "),writeln(PalpiteLugar),
            write("Arma: "),writeln(PalpiteArma),
            write("Pessoa: "),writeln(PalpitePessoa),
            len(Intercessao,Checkagem),
            (
                Checkagem =:= 0 -> writeln("Voce nao possui nenhuma carta."),
                write("O "),write(Nome),writeln(" jogou."),
                (Bot1.cont =:= 0 -> NovoBot = Bot1.put([cont:2,prioridades:[PalpiteLugar,PalpiteArma,PalpitePessoa]]),Acabou = false;
                NovoBot = Bot1.put([cont:3,prioridades:[PalpiteLugar,PalpiteArma,PalpitePessoa]]),Acabou = false
                )
            ;
                jogadorResponde(Intercessao,Desejado),
                write("O "),write(Nome),writeln(" jogou."),
                (member(Desejado,Bot1.lugares) -> remove(Desejado,Bot1.lugares,[],NovosLugares),Acabou = false,NovoBot = Bot1.put([lugares:NovosLugares,cont:0]);
                member(Desejado,Bot1.armas) -> remove(Desejado,Bot1.armas,[],NovasArmas),Acabou = false,NovoBot = Bot1.put([armas:NovasArmas,cont:0]);
                remove(Desejado,Bot1.pessoas,[],NovasPessoas),Acabou = false,NovoBot = Bot1.put([pessoas:NovasPessoas,cont:0]))
            )
        ;
            verificaCartas([PalpitePessoa, PalpiteLugar, PalpiteArma], Bot2.cartas, Intercessao),
	    len(Intercessao, Checkagem),
            write("O "),write(Nome),writeln(" jogou."),
            (
                Checkagem =:= 0 -> 
                (Bot1.cont =:= 0 -> NovoBot = Bot1.put([cont:1,prioridades:[PalpiteLugar,PalpiteArma,PalpitePessoa]]),Acabou = false;
                NovoBot = Bot1.put([cont:3,prioridades:[PalpiteLugar,PalpiteArma,PalpitePessoa]]),Acabou = false
                )
            ;
                random(0, Checkagem, F),
                nth0(F, Intercessao, Desejado),
                (member(Desejado, Bot1.lugares) -> remove(Desejado,Bot1.lugares,[],NovosLugares),Acabou = false, NovoBot = Bot1.put([lugares:NovosLugares,cont:0]);
                member(Desejado, Bot1.armas) ->  remove(Desejado,Bot1.armas,[],NovasArmas),Acabou = false, NovoBot = Bot1.put([armas:NovasArmas,cont:0]);
                remove(Desejado, Bot1.pessoas,[], NovasPessoas),Acabou = false, NovoBot = Bot1.put([pessoas:NovasPessoas,cont:0]))
            )
        )
    ).

escreveResposta(Resposta) :-
    write(Resposta.pessoa),write(" matou com um(a) "),write(Resposta.arma),
    write(" no(a) "),writeln(Resposta.lugar).

start(Pessoa,Bot1,Bot2,Resposta,Dados,"0") :-
    mostraMenu(Pessoa),
    read_line(Opcao),
    start(Pessoa,Bot1,Bot2,Resposta,Dados,Opcao).

start(Pessoa,Bot1,Bot2,Resposta,Dados,"1") :-	
    vezDoJogador(Pessoa,Bot1,Dados,NovaPessoa),nl,
    vezDoBot("Bot1",Pessoa,Bot1,Bot2,Resposta,NovoBot1,Acabou1),nl,
    (
        Acabou1 -> writeln("O BOT1 VENCEU O JOGO!"),
        escreveResposta(Resposta),start(Pessoa,Bot1,Bot2,Resposta,Dados,"5")
    ;
        vezDoBot("Bot2",Pessoa,Bot2,Bot1,Resposta,NovoBot2,Acabou2),nl,
        (
	    
            Acabou2 -> writeln("O BOT2 VENCEU O JOGO!"),
            escreveResposta(Resposta),start(Pessoa,Bot1,Bot2,Resposta,Dados,"5")
        ;
            start(NovaPessoa,NovoBot1,NovoBot2,Resposta,Dados,"0")
        )
        
    ).


start(Pessoa,Bot1,Bot2,Resposta,Dados,"2") :-
    vezDoJogador(Pessoa,Bot2,Dados,NovaPessoa),nl,
    vezDoBot("Bot1",Pessoa, Bot1, Bot2,Resposta, NovoBot1,Acabou1),nl,
    (
        Acabou1 -> writeln("O BOT1 VENCEU O JOGO!"),
        escreveResposta(Resposta),start(Pessoa,Bot1,Bot2,Resposta,Dados,"5")
    ;
        vezDoBot("Bot2",Pessoa,Bot2,Bot1,Resposta,NovoBot2,Acabou2),nl,
        (
            Acabou2 -> writeln("O BOT 2 VENCEU O JOGO!"),
            escreveResposta(Resposta),start(Pessoa,Bot1,Bot2,Resposta,Dados,"5")
        ;
            start(NovaPessoa,NovoBot1,NovoBot2,Resposta,Dados,"0")
        )
        
    ).

start(Pessoa,Bot1,Bot2,Resposta,Dados,"3") :-
    realizaPalpite(Resposta,Dados,Retorno),nl,
    (
        Retorno -> write("PARABENS, VOCE VENCEU O JOGO!, "),
	escreveResposta(Resposta),start(Pessoa,Bot1,Bot2,Resposta,Dados,"5")
    ;
        vezDoBot("Bot1",Pessoa, Bot1, Bot2,Resposta, NovoBot1,Acabou1),nl,
        (
            Acabou1 -> writeln("O BOT1 VENCEU O JOGO!"),
            escreveResposta(Resposta),start(Pessoa,Bot1,Bot2,Resposta,Dados,"5")
        ;
            vezDoBot("Bot2",Pessoa,Bot2,Bot1,Resposta,NovoBot2,Acabou2),nl,
            (
                Acabou2 -> writeln("O BOT2 VENCEU O JOGO!"),
                escreveResposta(Resposta),start(Pessoa,Bot1,Bot2,Resposta,Dados,"5")
            ;
                start(NovaPessoa,NovoBot1,NovoBot2,Resposta,Dados,"0")
            )
            
        )
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
