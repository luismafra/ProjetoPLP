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

void mostraPossiveis(JOGADOR usuario);

string ajeitaPalavra(string palavra) {
    string aux = "";
    aux += toupper(palavra[0]);

    for(int i = 1; i < palavra.size(); i++) {
        aux += tolower(palavra[i]);
    }
    return aux;
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

// Define os nomes dos possíveis locais no jogo
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

// Define os nomes das possíveis armas no jogo
void criaArmas(string armas[],	string bot1armas[], string bot2armas[], string usuarioarmas[]){
	armas[0] = "Machado";
	armas[1] = "Pa";
	armas[2] = "Arma quimica";
	armas[3] = "Revolver";
	armas[4] = "Faca";
	armas[5] = "Pe de cabra";
	armas[6] = "Veneno";
	armas[7] = "Corda";
	armas[8] = "Tesoura";
	
	for (int i = 0; i < 9; i++){
		bot1armas[i] = armas[i];
		bot2armas[i] = armas[i];
		usuarioarmas[i] = armas[i];	
	}
}

// Define os nomes dos possíveis supeitos no jogo
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

bool verifica(string algo, string array[]){
	for(int i = 0; i < 9; i++){
		if(array[i] == algo)
			return true;
	}
	return false;
}

// Vefifica se o Palpite do jogador foi correto
bool verificaResposta(RESPOSTA resposta, string lugar, string arma, string pessoa){

  if (resposta.lugar == lugar && resposta.arma == arma && resposta.pessoa == pessoa){
    cout << "PARABENS VOCE DESCOBRIU O ASSASSINO!!! " + pessoa + " matou com um(a) " + arma + " no(a) " + lugar << endl;  
    return true;
  }
  else{
    cout << "Voce errou, tente novamente na proxima rodada" << endl;
    return false;
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

			if(verifica(algo, base.lugares) == 1){
				retiraLugar(usuario, algo);
			}else if(verifica(algo, base.armas) == 1){
				retiraArma(usuario, algo);
			}else if(verifica(algo, base.pessoas) == 1){
				retiraPessoa(usuario, algo);
			}
			usuario->cartas[j] = algo;
			i -= 1;
		}
		
	}
	
}
// Realiza a resposta do jogo
void sorteiaResposta(RESPOSTA* resposta, DADOS base){
    srand(time(0));
    resposta->lugar = base.lugares[rand() % 9];
    resposta->arma = base.armas[rand() % 9];
    resposta->pessoa = base.pessoas[rand() % 9];
}

// Menu do jogo
void mostraMenu(JOGADOR usuario){
  cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl;
  cout << "-=-=                          Sua vez de jogar ...                           =-=-" << endl;
  cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl;
  mostraPossiveis(usuario);
  cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl;
	cout << "Escolha uma opcao" << endl;
	cout << "1 - Perguntar ao bot1" << endl;
  cout << "2 - Perguntar ao bot2" << endl;
  cout << "3 - Dar um palpite" << endl;
  cout << "4 - Para olhar suas cartas" << endl;
  cout << "5 - Sair" << endl;
  cout << "Opcao> ";
}

// Mostra quais as cartas possíveis que um jogador pode perguntar ao outro jogador
void mostraPossiveis(JOGADOR usuario){

	cout << "POSSIBILIDADES DE LUGARES PARA O JOGADOR:" << endl;
	for(int i = 0; i < usuario.index[0]; i++){
		if (i != usuario.index[0] - 1) cout << usuario.lugares[i] + ", ";
		else cout << usuario.lugares[i] + "." << endl << endl;
	}
	cout << "POSSIBILIDADES DE ARMAS PARA O JOGADOR:" << endl;
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

// Mostra as cartas que foram sortadas para o jogador
void mostrarCartasJogador(JOGADOR usuario){
    cout << "Mostrando suas cartas ..." << endl << endl;
	  for(int i = 0; i < 8; i++) {
      if (i < 7) cout << usuario.cartas[i] + ", ";
      else cout << usuario.cartas[i] + "." << endl << endl;;
	}  
}

// Cria o array com as 24 cartas que sobraram
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

// Verifica se o jogador possui alguma carta que foi lhe passada como cenário do crime
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
      jogador->prioridades[0] = "";
      jogador->prioridades[1] = "";
      jogador->prioridades[2] = "";
    mudado = cartasDoJogador[rand() % index];
    if(mudado == 0){
      retorno = "O jogador tinha " + lugar;    
      retiraLugar(jogador, lugar);
	}
  	else if(mudado == 1){
      retorno = "O jogador tinha " + arma;
      retiraArma(jogador, arma);
    }
    else if(mudado == 2){
      retorno = "O jogador tinha " + pessoa;
      retiraPessoa(jogador, pessoa);
    }
    return retorno;
  }
}

bool checaResposta(JOGADOR *bot, string resposta, string palpiteBotLugar, string palpiteBotArma, string palpiteBotPessoa){
    if(verifica(resposta, bot->lugares) == 1){
        retiraLugar(bot, resposta);
        return true;
    }
    else if(verifica(resposta, bot->armas) == 1){
        retiraArma(bot, resposta);
        return true;
    }
    else if(verifica(resposta, bot->pessoas) == 1){
        retiraPessoa(bot, resposta);
        return true;
    }
    else{
      return false;
    }
}

void exibeArray(string array[], int index){
    for(int i = 0; i < index; i++){
        if (i == index-1){
          cout << array[i] + "." << endl;
        } else {
          cout << array[i] + ", ";
        }
    }
}

bool botaJogar(JOGADOR *botjogando, JOGADOR *outroBot, JOGADOR *jogador, int* countPrioridade, RESPOSTA resposta) {
  srand(time(0));
  int chanceBotTentar = rand() % 10;
  if(*countPrioridade == 3){
      cout << "PARABENS VOCE DESCOBRIU O ASSASSINO!!! " + botjogando->prioridades[2] + " matou com um(a) " + botjogando->prioridades[1] + " no(a) " + botjogando->prioridades[0] << endl;
      return true;
  }
  if (chanceBotTentar < 7 || *countPrioridade == 0) {
      cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl;
      if(botjogando->index[0] == 1 && botjogando->index[1] == 1 && botjogando->index[2] == 1){
          cout << "PARABENS VOCE DESCOBRIU O ASSASSINO!!! " + botjogando->pessoas[0] + " matou com um(a) " + botjogando->armas[0] + " no(a) " + botjogando->lugares[0] << endl;
          return true;
      }
    string palpiteBotLugar;
    string palpiteBotArma;
    string palpiteBotPessoa;
    int aux;
    if(*countPrioridade == 1){
        aux = 1;
    }else if(*countPrioridade == 2){
        aux = 0;
    }else{
        aux = rand() % 2;
    }
    if (botjogando->prioridades[0] == "") {
    palpiteBotLugar = botjogando->lugares[rand() % botjogando->index[0]];
    } else {
    palpiteBotLugar = botjogando->prioridades[0];
    }
    if (botjogando->prioridades[1] == "") {
    palpiteBotArma = botjogando->armas[rand() % botjogando->index[1]];
    } else {
    palpiteBotArma = botjogando->prioridades[1];
    }
    if (botjogando->prioridades[2] == "") {
    palpiteBotPessoa = botjogando->pessoas[rand() % botjogando->index[2]];
    } else {
    palpiteBotPessoa = botjogando->prioridades[2];
    }
    botjogando->prioridades[0] = palpiteBotLugar;
    botjogando->prioridades[1] = palpiteBotArma;
    botjogando->prioridades[2] = palpiteBotPessoa;

    if (aux == 0) {
        cout << "=-=-                    O bot perguntou para o outro bot.                    =-=-" << endl;
        string retorno = verificaCartas(outroBot, palpiteBotLugar, palpiteBotArma, palpiteBotPessoa, botjogando);
        if(retorno == "O jogador nao tem nenhuma das 3 cartas."){
            if(*countPrioridade == 0){
                *countPrioridade = 1;
            }else{
                *countPrioridade = 3;
            }
        }else{
            *countPrioridade = 0;
        }
    } else {
        string possiveis[3];
        int index = 0;
        
        if (verifica(palpiteBotLugar, jogador->cartas)){
            possiveis[index] = ajeitaPalavra(palpiteBotLugar);;
            index++;
        }
        if (verifica(palpiteBotArma, jogador->cartas)){
            possiveis[index] = ajeitaPalavra(palpiteBotArma);;
            index++;
        }
        if (verifica(palpiteBotPessoa, jogador->cartas)){
            possiveis[index] = ajeitaPalavra(palpiteBotPessoa);;
            index++;
        }

        cout << "A pergunta do bot para voce foi:" << endl;
        cout << "Lugar: " + palpiteBotLugar << endl;
        cout << "Arma: " + palpiteBotArma << endl;
        cout << "Pessoa: " + palpiteBotPessoa << endl;
        
        if (index == 0){
            cout << "Voce nao possui nenhuma carta." << endl;
            if(*countPrioridade == 0){
                *countPrioridade = 2;
            }
            else{
                *countPrioridade = 3;
            }
        } else {
            string responde;
            cout << "Voce possui: " << endl;
            exibeArray(possiveis,index);
            cout << "Qual voce quer que ele saiba? ";
            getline(cin, responde);
            responde = ajeitaPalavra(responde);
            while(verifica(responde,possiveis) == false){
                cout << "Voce possui: " << endl;
                exibeArray(possiveis,index);
                cout << "Qual voce quer que ele saiba? ";
                getline(cin, responde);
                responde = ajeitaPalavra(responde);
            }
            cout << endl;
            checaResposta(botjogando, responde, palpiteBotLugar, palpiteBotArma, palpiteBotPessoa);
            
            botjogando->prioridades[0] = "";
            botjogando->prioridades[1] = "";
            botjogando->prioridades[2] = "";
            *countPrioridade = 0;
        }
        return false;
    }
  }
   else if (chanceBotTentar >= 7 && *countPrioridade > 0){

    if(botjogando->index[0] == 1 && botjogando->index[1] == 1 && botjogando->index[2] == 1){
        cout << "PARABENS VOCE DESCOBRIU O ASSASSINO!!! " + botjogando->pessoas[0] + " matou com um(a) " + botjogando->armas[0] + " no(a) " + botjogando->lugares[0] << endl;
        return true;
    }
    if (verificaResposta(resposta, botjogando->prioridades[0], botjogando->prioridades[1], botjogando->prioridades[2])) {
      return true;
    }
    else {
      cout << "O bot tentou adivinhar a resposta e errou!" << endl;
      botjogando->prioridades[0] = "";
      botjogando->prioridades[1] = "";
      botjogando->prioridades[2] = "";
      *countPrioridade = 0;
      return false;
    } 
   }
  return false;  
}


void cls(){
    if(getenv("windir") == NULL){
        system("clear");
    } else {
        system("cls");
    }
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
  definePrioridades(&bot1, &bot2);

  //Cria as cartas do jogo
  criaLugares(base.lugares, bot1.lugares, bot2.lugares, usuario.lugares);
  criaArmas(base.armas, bot1.armas, bot2.armas, usuario.armas);
  criaSuspeitos(base.pessoas, bot1.pessoas, bot2.pessoas, usuario.pessoas);
  
  //Sorteia a resposta do jogo
  sorteiaResposta(&resposta, base);
  string tudo [24];
  criaBaralho(base, resposta, tudo);
  sorteia(&bot1, &bot2, &usuario, base, tudo);

  char opcao;
  string palpiteLugar;
  string palpiteArma;
  string palpitePessoa;
  int countPrioridadeBot1 = 0;
  int countPrioridadeBot2 = 0;
  do{
      mostraMenu(usuario);
      cin >> opcao;
      flush();      
      switch(opcao) {
        case '1':{
              cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl;
              cout << "Pergunte ao Bot1 se ele tem um lugar, uma arma ou uma pessoa" << endl;
              cout << "Digite a lugar: ";
              getline(cin, palpiteLugar);
              palpiteLugar = ajeitaPalavra(palpiteLugar);
              cout << "Digite a arma: ";
              getline(cin, palpiteArma);
              palpiteArma = ajeitaPalavra(palpiteArma);
              cout << "Digite a pessoa: ";
              getline(cin, palpitePessoa);
              palpitePessoa = ajeitaPalavra(palpitePessoa);
              cout << endl;
              cout << verificaCartas(&bot1, palpiteLugar, palpiteArma, palpitePessoa, &usuario) << endl << endl;
        
              bool cont = botaJogar(&bot1, &bot2, &usuario, &countPrioridadeBot1, resposta);

              if(cont) {
                  opcao = '5';
                  cout << "VITORIA DO BOT 1!!" << endl;
                  break;
              }
              cont = botaJogar(&bot2, &bot1, &usuario, &countPrioridadeBot2, resposta);
              
              if(cont) {
                  opcao = '5';
                  cout << "VITORIA DO BOT 2!!" << endl;
                  break;
              }
        
              cls();
              break;
          }
          case '2': {
              cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl;
              cout << "Pergunte ao Bot2 se ele tem um lugar, uma arma ou uma pessoa" << endl;
              cout << "Digite a lugar: ";
              getline(cin, palpiteLugar);
              palpiteLugar = ajeitaPalavra(palpiteLugar);
              cout << "Digite a arma: ";
              getline(cin, palpiteArma);
              palpiteArma = ajeitaPalavra(palpiteArma);
              cout << "Digite a pessoa: ";
              getline(cin, palpitePessoa);
              palpitePessoa = ajeitaPalavra(palpitePessoa);
              cout << endl;
              cout << verificaCartas(&bot2, palpiteLugar, palpiteArma, palpitePessoa, &usuario) << endl << endl;

              bool cont = botaJogar(&bot1, &bot2, &usuario, &countPrioridadeBot1, resposta);

              if(cont){
                  opcao = '5';
                  cout << "VITORIA DO BOT 1!!" << endl;
                  break;
              }
              cont = botaJogar(&bot2, &bot1, &usuario, &countPrioridadeBot2, resposta);
              
              if(cont){
                  opcao = '5';
                  cout << "VITORIA DO BOT 2!!" << endl;
                  break;
              }      
              cls();
              break;
          }
          case '3':{
              cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl;
              cout << "De um palpite contendo um lugar, uma arma e uma pessoa" << endl;
              cout << "Digite a lugar: ";
              getline(cin, palpiteLugar);
              palpiteLugar = ajeitaPalavra(palpiteLugar);
              cout << "Digite a arma: ";
              getline(cin, palpiteArma);
              palpiteArma = ajeitaPalavra(palpiteArma);
              cout << "Digite a pessoa: ";
              getline(cin, palpitePessoa);
              palpitePessoa = ajeitaPalavra(palpitePessoa);
              cout << endl;
              cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl;
              
              bool cont = verificaResposta(resposta, palpiteLugar, palpiteArma, palpitePessoa);

              cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl;
              
              if(cont){
                  opcao = '5';
                  cout << "VITORIA DO JOGADOR!!" << endl;
              } else {
                  cont = botaJogar(&bot1, &bot2, &usuario, &countPrioridadeBot1, resposta);
                  if(cont){
                      opcao = '5';
                      cout << "VITORIA DO BOT 1!!" << endl;
                      break;
                  }
                  cont = botaJogar(&bot2, &bot1, &usuario, &countPrioridadeBot2, resposta);
                  if(cont){
                      opcao = '5';
                      cout << "VITORIA DO BOT 2!!" << endl;
                      break;
                  }
              }
              cls();
              break;
              }
          case '4':{
              cls();
              mostrarCartasJogador(usuario);
              cout << "Pressione qualquer tecla e aperte ENTER para continuar...";
              getchar();
              break;
          }
          case '5':{
              break;
          }
          default:{
              cls();
              cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" << endl;
              cout << endl << endl << "OPCAO INVALIDA! TENTE NOVAMENTE" << endl << endl << endl;
              break;
          }
      }
    } while(opcao != '5');
  return 0;
}