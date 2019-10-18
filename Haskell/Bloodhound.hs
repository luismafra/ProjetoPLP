-- Por favor, rodar o codigo com runhaskell bloodhound.hs

import GameFunctions
import Structs

main = do 
    let lugares = ["Lavanderia", "Banco" , "Estadio", "Cinema", "Floresta", "Escola", "Igreja", "Shopping", "Praia"]
    let armas = ["Machado", "Pa", "Arma quimica", "Revolver", "Faca", "Pe de cabra", "Veneno", "Corda", "Tesoura"]
    let pessoas = ["Johann", "Matias", "Clarisse", "Alfred", "Jasmine", "Rosa", "Taylor", "Solomon", "Viktor"]
    let prioridades = ["", "", ""]

    let base = DADOS lugares armas pessoas
    let pessoa = JOGADOR lugares armas pessoas prioridades [] 0
    let bot1 = JOGADOR lugares armas pessoas prioridades [] 0
    let bot2 = JOGADOR lugares armas pessoas prioridades [] 0
    
    resposta <- sorteiaResposta base
    let baralho = criaBaralho base resposta

    aux <- sorteiaCartas 8 baralho base []
    let pessoa = fst aux
    let baralho = snd aux

    aux <- sorteiaCartas 8 baralho base []
    let bot1 = fst aux
    let baralho = snd aux

    aux <- sorteiaCartas 8 baralho base []
    let bot2 = fst aux
    let baralho = snd aux

    start pessoa bot1 bot2 resposta base "0"