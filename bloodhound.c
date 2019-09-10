#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <math.h>
#include <time.h>

typedef struct{
	char* lugares[9];
	char* armas[9];
	char* pessoas[9];
	char* prioridade[3];
	char* cartas[8];
	int cont;
	int index[3];
 } JOGADOR;

typedef struct{
	char* lugares[9];
	char* armas[9];
	char* pessoas[9];  
} DADOS;

typedef struct{
	char* lugar;
	char* arma;
	char* pessoa;
} RESPOSTA;

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
void criaLugares(char* lugares[], char* bot1lugares[], char* bot2lugares[], char* usuariolugares[]){
	
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
void criaArmas(char* armas[],char* bot1armas[], char* bot2armas[], char* usuarioarmas[]){
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
void criaSuspeitos(char* pessoas[], char* bot1pessoas[], char* bot2pessoas[], char* usuariopessoas[]){
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
int verifica(char* algo, char* array[]){
	for(int i = 0; i < 9; i++){
		if(array[i] == algo)
			return 1;
	}
	return 0;
}
void retiraLugar(JOGADOR *bot, char* algo){
	int i;
	for(i = 0; i < bot->index[0]; i++){
		if(bot->lugares[i] == algo){
			break;
		}
	}
	bot->lugares[i] = bot->lugares[bot->index[0] - 1];
	bot->index[0]--;
}
void retiraArma(JOGADOR *bot, char* algo){
	int i;
	for(i = 0; i < bot->index[1]; i++){
		if(bot->armas[i] == algo){
			break;
		}
	}
	bot->armas[i] = bot->armas[bot->index[1] - 1];
	bot->index[1]--;
}
void retiraPessoa(JOGADOR *bot, char* algo){
	int i;
	for(i = 0; i < bot->index[2]; i++){
		if(bot->pessoas[i] == algo){
			break;
		}
	}
	bot->pessoas[i] = bot->pessoas[bot->index[2] - 1];
	bot->index[2]--;
}
void retiraTudo(char* tudo[], char* algo, int index){
	int i;
	for(i = 0; i < index; i++){
		if(tudo[i] == algo){
			break;
		}
	}
	tudo[i] = tudo[index - 1];
}
void sortea(JOGADOR *bot1,JOGADOR *bot2,JOGADOR *usuario,DADOS base, char* tudo[]){
	time_t t;
	srand((unsigned) time(&t));
	int i = 24;

	while(i > 0){
		for(int j = 0; j < 8; j++){
			char* algo = tudo[rand()%i];
			if(verifica(algo,base.lugares) == 1){
				retiraLugar(bot1,algo);
				retiraTudo(tudo,algo,i);
			}else if(verifica(algo,base.armas) == 1){
				retiraArma(bot1,algo);
				retiraTudo(tudo,algo,i);
			}else if(verifica(algo,base.pessoas) == 1){
				retiraPessoa(bot1,algo);
				retiraTudo(tudo,algo,i);
			}
			bot1->cartas[j] = algo;
			i -= 1;
		}

		for(int j = 0; j < 8; j++){
			char* algo = tudo[rand()%i];
			if(verifica(algo,base.lugares) == 1){
				retiraLugar(bot2,algo);
				retiraTudo(tudo,algo,i);
			}else if(verifica(algo,base.armas) == 1){
				retiraArma(bot2,algo);
				retiraTudo(tudo,algo,i);
			}else if(verifica(algo,base.pessoas) == 1){
				retiraPessoa(bot2,algo);
				retiraTudo(tudo,algo,i);
			}
			bot2->cartas[j] = algo;
			i -= 1;
		}

		for(int j = 0; j < 8; j++){
			char* algo = tudo[j];
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
	time_t t;
	srand((unsigned) time(&t));
	resposta->lugar = base.lugares[rand()%9];
  	resposta->arma = base.armas[rand()%9];
  	resposta->pessoa = base.pessoas[rand()%9];
}
void mostraMenu(){
	printf("Escolha uma opcao\n");
	printf("1 - Perguntar ao bot1\n");
  	printf("2 - Perguntar ao bot2\n");
  	printf("3 - Dar um palpite\n");
  	printf("4 - Sair\n");
  	printf("Opcao> ");
}
void mostraPossiveis(JOGADOR usuario, DADOS base){
	//for (int i = 0; i < base.)
	printf("POSSIBILIDADES DE LUGARES PARA O JOGADOR:\n\n");
	for(int i = 0; i < usuario.index[0]; i++){
		if (i != usuario.index[0] - 1) printf("%s, ", usuario.lugares[i]);
		else printf("%s.\n\n", usuario.lugares[i]);
	}
	printf("POSSIBILIDADES DE ARMAS PARA O JOGADOR:\n\n");
	for(int i = 0; i < usuario.index[1]; i++){
		if (i != usuario.index[1] - 1) printf("%s, ", usuario.armas[i]);
		else printf("%s.\n\n", usuario.armas[i]);		
	}
	printf("POSSIBILIDADES DE PESSOAS PARA O JOGADOR:\n\n");
	for(int i = 0; i < usuario.index[2]; i++){
		if (i != usuario.index[2] - 1) printf("%s, ", usuario.pessoas[i]);
		else printf("%s.\n\n", usuario.pessoas[i]);		
	}
}
void criaBaralho(DADOS base, RESPOSTA resposta, char* tudo[]){
	int i = 0;
  	//Cria o array com tudo que sobrou(24 cartas)
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

int main(void) {

  //Cria os jogadores e a base de dados
  DADOS base;
  JOGADOR bot1;
  JOGADOR bot2;
  JOGADOR usuario;
  RESPOSTA resposta;

  //Define os indices para auxiliar
  defineIndices(&bot1,&bot2,&usuario);

  //Cria as cartas do jogo
  criaLugares(base.lugares,bot1.lugares,bot2.lugares,usuario.lugares);
  criaArmas(base.armas,bot1.armas,bot2.armas,usuario.armas);
  criaSuspeitos(base.pessoas,bot1.pessoas,bot2.pessoas,usuario.pessoas);
  
  //Sorteia a resposta do jogo
  sorteiaResposta(&resposta, base);
  printf("%s %s %s", resposta.lugar, resposta.arma, resposta.pessoa);
  char* tudo [24];
  criaBaralho(base, resposta, tudo);
 /* for(int j = 0; j < 9; j++){
	printf("%s\n",bot1.lugares[j]);
  }
  retiraLugar(&bot1,bot1.lugares[4]);
  for(int j = 0; j < bot1.index[0]; j++){
	printf("%s\n",bot1.lugares[j]);
  }
  retiraLugar(&bot1,bot1.lugares[3]);
  for(int j = 0; j < bot1.index[0]; j++){
	printf("%s\n",bot1.lugares[j]);
  } */
  sortea(&bot1,&bot2,&usuario,base,tudo);
  int opcao;
  do{
	  mostraPossiveis(usuario, base);
	  mostraMenu();
	  scanf("%d", &opcao);
	  switch(opcao){
		  case 1:{
			  printf("Digite a pessoa: ");
			  printf("Digite a pessoa: ");
			  printf("Digite a pessoa: ");
		  }
		  case 2:{

		  }
		  case 3:{

		  }
		  case 4:{
			break;
		  }
		  default:{
			  printf("\nOPCAO INVALIDA! TENTE NOVAMENTE\n");
			  printf("--------------------------------\n\n");
		  }
	  }

  } while(opcao != 4);
  
  //Escolha uma opção
  //1 - Perguntar ao bot1
  //2 - Perguntar ao bot2
  //3 - Dar um palpite
  //4 - Sair
  //Opção> 1
  //Digite a pessoa:
  //Digite a arma:
  //Digite o lugar:
  //Bot1 não possui nenhum deles
  //Bot1 possui X
  
  return 0;
}