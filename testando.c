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
	int cont;
	int index[3];
  }BOT;
typedef struct {
	char* lugares[9];
	char* armas[9];
	char* pessoas[9];  
  }DADOS;
void defineIndices(BOT bot1, BOT bot2){
	bot1.index[0] = 9;
	bot1.index[1] = 9;
	bot1.index[2] = 9;
	bot2.index[0] = 9;
	bot2.index[1] = 9;
	bot2.index[2] = 9;
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
void retiraLugar(BOT bot, char* algo){
	int i;
	for(i = 0; i < bot.index[0]; i++){
		if(bot.lugares[i] == algo){
			break;
		}
	}
	bot.lugares[i] = bot.lugares[bot.index[0] - 1];
	bot.index[0]--;
}

void sortea(BOT bot1, BOT bot2, DADOS usuario, DADOS base, char* tudo[]){
	time_t t;
	srand((unsigned) time(&t));
	int i = 24;
	while(i > 0){
		for(int j = 0; j < 8; j++){
			char* algo = tudo[rand()%i];
			if(verifica(algo,base.lugares) == 1){
				retiraLugar(bot1.lugares,algo);
			}
		}
	}
	
}


int main(void) {
  
  time_t t;
  srand((unsigned) time(&t));
  //for(int i = 0; i < 5; i++){
	//printf("%d \n", rand()%1);
  //} 
  DADOS base;
  BOT bot1;
  BOT bot2;
  DADOS usuario;
  defineIndices(bot1,bot2);
  criaLugares(base.lugares,bot1.lugares,bot2.lugares,usuario.lugares);
  criaArmas(base.armas,bot1.armas,bot2.armas,usuario.armas);
  criaSuspeitos(base.pessoas,bot1.pessoas,bot2.pessoas,usuario.pessoas);
  
  char* lugar = base.lugares[rand()%9];
  char* arma = base.armas[rand()%9];
  char* pessoa = base.pessoas[rand()%9];
  
  char* tudo[24];
  int i = 0;
  while(i < 24){
	for(int j = 0; j < 9;j++){
		if(base.lugares[j] != lugar){
			tudo[i] = base.lugares[j];
			i += 1;
		}
	}
	for(int j = 0; j < 9;j++){
		if(base.armas[j] != arma){
			tudo[i] = base.armas[j];
			i += 1;
		}
	}
	for(int j = 0; j < 9;j++){
		if(base.pessoas[j] != pessoa){
			tudo[i] = base.pessoas[j];
			i += 1;
		}
	}
  }
  for(int j = 0; j < 9; j++){
	printf("%s\n",bot1.lugares[j]);
  }
  
  retiraLugar(bot1,bot1.lugares[4]);
  for(int j = 0; j < 9; j++){
	printf("%s\n",bot1.lugares[j]);
  }
  
  //sortea(bot1,bot2,usuario,base,tudo);
  
  
  //int boolean = 1;
  //while(boolean == 1){
	
  //}
  //char* tudo[24];
  
  
  
  //Escolha uma opção
  //1 - Perguntar ao bot1
  //2 - Perguntar ao bot2
  //3 - Dar um palpite
  //Opção> 1
  //Digite a pessoa:
  //Digite a arma:
  //Digite o lugar:
  //Bot1 não possui nenhum deles
  //Bot1 possui X
  
  return 0;
}
