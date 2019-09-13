#include <iostream>
using std::cout;
using std::cin;
using std::endl;

#include <string>
using std::string;
using std::getline;

#include <ctime>
#include <cstdlib>
#include <cstdio>

using namespace std;

typedef struct{
	string lugares[9];
	string armas[9];
	string pessoas[9];
	string prioridades[3];
	string cartas[8];
	int cont;
	int index[3];
 } JOGADOR;

typedef struct{
	string lugares[9];
	string armas[9];
	string pessoas[9];  
} DADOS;

typedef struct{
	string lugar;
	string arma;
	string pessoa;
} RESPOSTA;

//Funcoes do programa

//funcao para limpar o buffer de entrada.
void flush() {
    int ch;
    while ( ( ch = fgetc ( stdin ) ) != EOF && ch != '\n' ) {}
}

void definePrioridades(JOGADOR *bot1, JOGADOR *bot2){
    bot1->prioridades[0] = "";
    bot1->prioridades[1] = "";
    bot1->prioridades[2] = "";
    bot2->prioridades[0] = "";
    bot2->prioridades[1] = "";
    bot2->prioridades[2] = "";
}

void defineIndices(JOGADOR *bot1, JOGADOR *bot2, JOGADOR *usuario){
	bot1->index[0] = 9;
	bot1->index[1] = 9;
	bot1->index[2] = 9;
	bot2->index[0] = 9;
	bot2->index[1] = 9;
	bot2->index[2] = 9;
	usuario->index[0] = 9;
	usuario->index[1] = 9;
	usuario->index[2] = 9;
}

void criaLugares(string lugares[], string bot1lugares[], string bot2lugares[], string usuariolugares[]){
	lugares[0] = "Lavanderia";
	lugares[1] = "Banco";
	lugares[2] = "Estadio";
	lugares[3] = "Cinema";
	lugares[4] = "Floresta";
	lugares[5] = "Escola";
	lugares[6] = "Igreja";
	lugares[7] = "Shopping";
	lugares[8] = "Praia";
	
	for (int i = 0; i < 9; i++){
		bot1lugares[i] = lugares[i];
		bot2lugares[i] = lugares[i];
		usuariolugares[i] = lugares[i];	
	}
}

void criaArmas(string armas[],	string bot1armas[], string bot2armas[], string usuarioarmas[]){
	armas[0] = "Machado";
	armas[1] = "Pa";
	armas[2] = "Arma Quimica";
	armas[3] = "Revolver";
	armas[4] = "Faca";
	armas[5] = "Pe de Cabra";
	armas[6] = "Veneno";
	armas[7] = "Corda";
	armas[8] = "Tesoura";
	
	for (int i = 0; i < 9; i++){
		bot1armas[i] = armas[i];
		bot2armas[i] = armas[i];
		usuarioarmas[i] = armas[i];	
	}
}

void criaSuspeitos(string pessoas[], string bot1pessoas[], string bot2pessoas[], string usuariopessoas[]){
	pessoas[0] = "Johann";
	pessoas[1] = "Matias";
	pessoas[2] = "Clarisse";
	pessoas[3] = "Alfred";
	pessoas[4] = "Jasmine";
	pessoas[5] = "Rosa";
	pessoas[6] = "Taylor";
	pessoas[7] = "Solomon";
	pessoas[8] = "Viktor";
	
	for (int i = 0; i < 9; i++){
		bot1pessoas[i] = pessoas[i];
		bot2pessoas[i] = pessoas[i];
		usuariopessoas[i] = pessoas[i];	
	}
}

int verifica(string algo, string array[]){
	for(int i = 0; i < 9; i++){
		if(array[i] == algo)
			return 1;
	}
	return 0;
}

int verificaResposta(RESPOSTA resposta, string lugar, string arma, string pessoa){
  int acertou = 0;
  for (int i = 0; i < 3 ; i++){
    if(resposta.lugar == lugar) acertou ++;
    else if(resposta.arma == arma) acertou++;
    else if(resposta.pessoa == pessoa) acertou ++;
  }

  if (acertou == 3){
    cout << "PARABENS VOCE DESCOBRIU O ASSASSINO!!! " + pessoa + " matou com um(a) " + arma + " no(a) " + lugar << endl;  
    return acertou;
  }
  else{
    cout << "Voce errou, tente novamente na proxima rodada" << endl;
    return acertou;
  }
}

void retiraLugar(JOGADOR *bot, string algo){
	int i;
	for(i = 0; i < bot->index[0]; i++){
		if(bot->lugares[i] == algo){
			break;
		}
	}
    bot->index[0]--;
    //cout << bot->index[0], bot->lugares[0];
	  bot->lugares[i] = bot->lugares[bot->index[0]];    
}

void retiraArma(JOGADOR *bot, string algo){
	int i;
	for(i = 0; i < bot->index[1]; i++){
		if(bot->armas[i] == algo){
			break;
		}
	}
	bot->armas[i] = bot->armas[bot->index[1] - 1];
	bot->index[1]--;
}

void retiraPessoa(JOGADOR *bot, string algo){
	int i;
	for(i = 0; i < bot->index[2]; i++){
		if(bot->pessoas[i] == algo){
			break;
		}
	}
	bot->pessoas[i] = bot->pessoas[bot->index[2] - 1];
	bot->index[2]--;
}

void retiraTudo(string tudo[], string algo, int index){
	int i;
	for(i = 0; i < index; i++){
		if(tudo[i] == algo){
			break;
		}
	}
	tudo[i] = tudo[index - 1];
}

void sorteia(JOGADOR *bot1, JOGADOR *bot2, JOGADOR *usuario, DADOS base, string tudo[]){
    srand(time(0));
	int i = 24;

	while(i > 0){
		for(int j = 0; j < 8; j++){ 
			string algo = tudo[rand() % i];

			if(verifica(algo, base.lugares) == 1){
				retiraLugar(bot1, algo);
				retiraTudo(tudo, algo, i);
			} else if(verifica(algo, base.armas) == 1){
				retiraArma(bot1, algo);
				retiraTudo(tudo, algo, i);
			} else if(verifica(algo, base.pessoas) == 1){
				retiraPessoa(bot1, algo);
				retiraTudo(tudo, algo, i);
			}

			bot1->cartas[j] = algo;
			i -= 1;
		}

		for(int j = 0; j < 8; j++){
			string algo = tudo[rand() % i];

			if(verifica(algo, base.lugares) == 1){
				retiraLugar(bot2, algo);
				retiraTudo(tudo, algo, i);
			}else if(verifica(algo, base.armas) == 1){
				retiraArma(bot2, algo);
				retiraTudo(tudo, algo, i);
			}else if(verifica(algo, base.pessoas) == 1){
				retiraPessoa(bot2, algo);
				retiraTudo(tudo, algo, i);
			}

			bot2->cartas[j] = algo;
			i -= 1;
		}

		for(int j = 0; j < 8; j++){
			string algo = tudo[j];

			if(verifica(algo,base.lugares) == 1){
				retiraLugar(usuario,algo);
			}else if(verifica(algo,base.armas) == 1){
				retiraArma(usuario,algo);
			}else if(verifica(algo,base.pessoas) == 1){
				retiraPessoa(usuario,algo);
			}
			usuario->cartas[j] = algo;
			i -= 1;
		}
		
	}
	
}

void sorteiaResposta(RESPOSTA* resposta, DADOS base){
    srand(time(0));
    resposta->lugar = base.lugares[rand() % 9];
    resposta->arma = base.armas[rand() % 9];
    resposta->pessoa = base.pessoas[rand() % 9];
}

void mostraMenu(){
	cout << ("Escolha uma opcao\n");
	cout << ("1 - Perguntar ao bot1\n");
  	cout << ("2 - Perguntar ao bot2\n");
  	cout << ("3 - Dar um palpite\n");
    cout << ("4 - Para olhar suas cartas\n");
  	cout << ("5 - Sair\n");
  	cout << ("Opcao> ");
}

void mostraPossiveis(JOGADOR usuario){

	cout << "POSSIBILIDADES DE LUGARES PARA O JOGADOR:\n" << endl;
	for(int i = 0; i < usuario.index[0]; i++){
		if (i != usuario.index[0] - 1) cout << usuario.lugares[i] + ", ";
		else cout << usuario.lugares[i] + "." << endl << endl;
	}
	cout << "POSSIBILIDADES DE ARMAS PARA O JOGADOR:\n" << endl;
	for(int i = 0; i < usuario.index[1]; i++){
		if (i != usuario.index[1] - 1) cout << usuario.armas[i] + ", ";
		else cout << usuario.armas[i] + "." << endl << endl;	
	}
	cout << "POSSIBILIDADES DE PESSOAS PARA O JOGADOR:" << endl;
	for(int i = 0; i < usuario.index[2]; i++){
		if (i != usuario.index[2] - 1) cout << usuario.pessoas[i] + ", ";
		else cout << usuario.pessoas[i] + "." << endl;
	}
}

//TODO
void mostrarCartasJogador(JOGADOR usuario){
    cout << "Mostrando suas cartas ..." << endl << endl;
	  for(int i = 0; i < 8; i++) {
      if (i < 7) cout << usuario.cartas[i] + ", ";
      else cout << usuario.cartas[i] + "." << endl << endl;;
	}  
}

//Cria o array com as 24 cartas que sobraram
void criaBaralho(DADOS base, RESPOSTA resposta, string tudo[]){
	int i = 0;
  
	while(i < 24){
		for(int j = 0; j < 9;j++){
			if(base.lugares[j] != resposta.lugar){
				tudo[i] = base.lugares[j];
				i += 1;
			}
		}
		for(int j = 0; j < 9;j++){
			if(base.armas[j] != resposta.arma){
				tudo[i] = base.armas[j];
				i += 1;
			}
		}
		for(int j = 0; j < 9;j++){
			if(base.pessoas[j] != resposta.pessoa){
				tudo[i] = base.pessoas[j];
				i += 1;
			}
		}
	}
}

string verificaCartas(JOGADOR *bot, string lugar, string arma, string pessoa, JOGADOR *jogador){
    srand(time(0));
    int mudado;
    int cartasDoJogador[3];
    int index = 0;
    string retorno = "O jogador nao tem nenhuma das 3 cartas.";  

  for (int i = 0; i < 8; i++){
    if(bot->cartas[i] == lugar){
  		cartasDoJogador[index] = 0;
      index++;
    } else if(bot->cartas[i] == arma){
  		cartasDoJogador[index] = 1;
      index++;
		} else if(bot->cartas[i] == pessoa){
  		cartasDoJogador[index] = 2;
      index++;
		}
	}
  if (index == 0) return retorno;
  else {
    mudado = cartasDoJogador[rand() % index];
    if(mudado == 0){
      jogador->prioridades[0] = "";
      retiraLugar(jogador, lugar);
	}
  	else if(mudado == 1){
      jogador->prioridades[1] = "";
      retiraArma(jogador, arma);
    }
    else if(mudado == 2){
      jogador->prioridades[2] = "";
      retiraPessoa(jogador, pessoa);
    }
    return retorno;
  }
}

void checaResposta(JOGADOR *bot, string resposta){
    if(verifica(resposta, bot->lugares) == 1){
        retiraLugar(bot,resposta);
    }
    else if(verifica(resposta, bot->armas) == 1){
        retiraArma(bot,resposta);
    }
    else{
        retiraPessoa(bot,resposta);
    }
}

void exibeArray(string array[]){
    for(int i = 0; i < 3; i++){
        if(i == 2){
            cout << array[i] + "." << endl;
        }if(array[i] == ""){
            continue;
        }
        else{
            cout << array[i] + ", ";
        }
    }
}
int botajogar(JOGADOR *botjogando, JOGADOR *outroBot, JOGADOR *jogador) {
    if(botjogando->index[0] == 1 && botjogando->index[1] == 1 && botjogando->index[2] == 1){
        return 3;
    }
  string palpiteBotLugar;
  string palpiteBotArma;
  string palpiteBotPessoa;
  int aux = rand()%2;

  if (botjogando->prioridades[0] == "") {
		palpiteBotLugar = botjogando->lugares[rand()%botjogando->index[0]];
  }
  else {
    palpiteBotLugar = botjogando->prioridades[0];
  }
  
  if (botjogando->prioridades[1] == "") {
		palpiteBotArma = botjogando->armas[rand()%botjogando->index[1]];
  }
  else {
    palpiteBotArma = botjogando->prioridades[1];
  }
  
  if (botjogando->prioridades[2] == "") {
		palpiteBotPessoa = botjogando->pessoas[rand()%botjogando->index[2]];
  }
  else {
    palpiteBotPessoa = botjogando->prioridades[2];
  }
  botjogando->prioridades[0] = palpiteBotLugar;
  botjogando->prioridades[1] = palpiteBotArma;
  botjogando->prioridades[2] = palpiteBotPessoa;

  if(aux == 0) {
  	verificaCartas(outroBot, palpiteBotLugar, palpiteBotArma, palpiteBotPessoa, botjogando);
	}
  else{

      string possiveis[3];
      int index = 0;
      if(verifica(palpiteBotLugar, jogador->cartas) == 1){
          possiveis[index] = palpiteBotLugar;
          index++;
      }
      if(verifica(palpiteBotArma, jogador->cartas) == 1){
          possiveis[index] = palpiteBotArma;
          index++;
      }
      if(verifica(palpiteBotPessoa, jogador->cartas) == 1){
          possiveis[index] = palpiteBotPessoa;
          index++;
      }

      cout << "A pergunta do bot para você foi:" << endl;
      cout << "Lugar: " + palpiteBotLugar << endl;
      cout << "Arma: " + palpiteBotArma << endl;
      cout << "Pessoa: " + palpiteBotPessoa << endl;
      if(index == 0){
          cout << "Você não possui nenhuma carta." << endl;
      }else{
          string responde;
          cout << "Você possui: " << endl;
          exibeArray(possiveis);
          cout << "Qual você quer que ele saiba? ";
          getline(cin, responde);
          checaResposta(botjogando,responde);
          
      }
  }
  return 0;
}


int main(void) {

  //Cria os jogadores e a base de dados
  DADOS base;
  JOGADOR bot1;
  JOGADOR bot2;
  JOGADOR usuario;
  RESPOSTA resposta;

  //Define os indices para auxiliar
  defineIndices(&bot1, &bot2, &usuario);
  //Inicializando prioridades como vazio
  definePrioridades(&bot1,&bot2);

  //Cria as cartas do jogo
  criaLugares(base.lugares, bot1.lugares, bot2.lugares, usuario.lugares);
  criaArmas(base.armas, bot1.armas, bot2.armas, usuario.armas);
  criaSuspeitos(base.pessoas, bot1.pessoas, bot2.pessoas, usuario.pessoas);
  
  //Sorteia a resposta do jogo
  sorteiaResposta(&resposta, base);
  string tudo [24];
  criaBaralho(base, resposta, tudo);
  sorteia(&bot1, &bot2, &usuario, base, tudo);

  int opcao;
  string palpiteLugar;
  string palpiteArma;
  string palpitePessoa;

  do{
      cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl;
      cout << "-=-=                 Sua vez de jogar ...                  =-=-" << endl;
      cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl;
      mostraPossiveis(usuario);
      cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl << endl << endl;
      mostraMenu();
      cin >> opcao;
      flush();
      switch(opcao){
        case 1:{
          cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl;
          cout << "Pergunte ao Bot1 se ele tem um lugar, uma arma ou uma pessoa" << endl;
          cout << "Digite a lugar: ";
          getline(cin, palpiteLugar);
          cout << "Digite a arma: ";
          getline(cin, palpiteArma);
          cout << "Digite a pessoa: ";
          getline(cin, palpitePessoa);
          cout << "\n";
          cout << verificaCartas(&bot1, palpiteLugar, palpiteArma, palpitePessoa, &usuario) << endl << endl;
          cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl << endl << endl;
          int cont;
          cont = botajogar(&bot1,&bot2,&usuario);
          if(cont == 3){
              opcao = 5;
              cout << "BOT 1 DEU UM PALPITE E GANHOU O JOGO!" << endl;
              break;
          }
          cont = botajogar(&bot2,&bot1,&usuario);
          if(cont == 3){
            opcao = 5;
            cout << "BOT 2 DEU UM PALPITE E GANHOU O JOGO!" << endl;
            break;
          }
          break;
        }
        case 2:{
          cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl;
          cout << "Pergunte ao Bot2 se ele tem um lugar, uma arma ou uma pessoa" << endl;
          cout << "Digite a lugar: ";
          getline(cin, palpiteLugar);
          cout << "Digite a arma: ";
          getline(cin, palpiteArma);
          cout << "Digite a pessoa: ";
          getline(cin, palpitePessoa);
          cout << "\n";
          cout << verificaCartas(&bot2, palpiteLugar, palpiteArma, palpitePessoa, &usuario) << endl << endl;
          cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"  << endl << endl << endl;
          int cont;
          cont = botajogar(&bot1,&bot2,&usuario);
          if(cont == 3){
              opcao = 5;
              cout << "BOT 1 DEU UM PALPITE E GANHOU O JOGO!" << endl;
              break;
          }
          cont = botajogar(&bot2,&bot1,&usuario);
          if(cont == 3){
            opcao = 5;
            cout << "BOT 2 DEU UM PALPITE E GANHOU O JOGO!" << endl;
            break;
          }      
          break;
        }
        case 3:{
          cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl;
          cout << "De um palpite contendo um lugar, uma arma e uma pessoa" << endl;
          cout << "Digite a lugar: ";
          getline(cin, palpiteLugar);
          cout << "Digite a arma: ";
          getline(cin, palpiteArma);
          cout << "Digite a pessoa: ";
          getline(cin, palpitePessoa);
          cout << "\n";
          cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl;
          int cont = verificaResposta(resposta, palpiteLugar, palpiteArma, palpitePessoa);
          cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl;
          if(cont == 3){
              opcao = 5;
          }else{
              cont = botajogar(&bot1,&bot2,&usuario);
              if(cont == 3){
                  opcao = 5;
                  cout << "BOT 1 DEU UM PALPITE E GANHOU O JOGO!" << endl;
                  break;
              }
              cont = botajogar(&bot2,&bot1,&usuario);
              if(cont == 3){
                  opcao = 5;
                  cout << "BOT 2 DEU UM PALPITE E GANHOU O JOGO!" << endl;
                  break;
              }
          }
          break;
        }
        case 4:{
          mostrarCartasJogador(usuario);
          break;

        }
        case 5:{
          break;
        }
        default:{
          cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl;
          cout << "\n\nOPCAO INVALIDA! TENTE NOVAMENTE\n\n\n";
          break;
        }

      }
    

  } while(opcao != 5);
  
  //Escolha uma opção
  //1 - Perguntar ao bot1
  //2 - Perguntar ao bot2
  //3 - Dar um palpite
  //4 - Olhar suas cartas
  //5 - Sair
  //Opção> 1
  //Digite a pessoa:
  //Digite a arma:
  //Digite o lugar:
  //Bot1 não possui nenhum deles
  //Bot1 possui X
  
  return 0;
}          