import System.random 


data Tuple = JOGADOR [String] [String] [String] [String] [String] |
             DADOS [String] [String] [String] |
             RESPOSTA String String String

getLugar :: Tuple -> String
getPessoa :: Tuple -> String
getArma :: Tuple -> String
getLugares :: Tuple -> [String]
getArmas :: Tuple -> [String]
getPessoas :: Tuple -> [String]
remove :: String -> [String] -> [String]


getLugar (RESPOSTA lugar arma pessoa) = lugar
getArma (RESPOSTA lugar arma pessoa) = arma
getPessoa (RESPOSTA lugar arma pessoa) = pessoa

getLugares (DADOS lugares armas pessoas) = lugares 
getArmas (DADOS lugares armas pessoas) = armas 
getPessoas (DADOS lugares armas pessoas) = pessoas 

remove element list = filter (\e -> e/=element) list

main = do 
    let lugares = ["Lavanderia", "Banco" , "Estadio", "Cinema", "Floresta", "Escola", "Igreja", "Shopping", "Praia"]
    let armas = ["Machado", "Pa", "Arma quimica", "Revolver", "Faca", "Pe de cabra", "Veneno", "Corda", "Tesoura"]
    let pessoas = ["Johann", "Matias", "Clarisse", "Alfred", "Jasmine", "Rosa", "Taylor", "Solomon", "Viktor"]
    let prioridades = ["", "", ""]
    let cartas = []

    base = DADOS lugares armas pessoas
    pessoa = JOGADOR lugares armas pessoas prioridades cartas
    bot1 = JOGADOR lugares armas pessoas prioridades cartas
    bot2 = JOGADOR lugares armas pessoas prioridades cartas

    




