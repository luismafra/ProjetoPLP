data Tuple = JOGADOR [String] [String] [String] [String] [String] |
             DADOS [String] [String] [String] |
             RESPOSTA String String String

getLugar :: Tuple -> String
getPessoa :: Tuple -> String
getArma :: Tuple -> String

getLugar (RESPOSTA lugar arma pessoa) = lugar
getArma (RESPOSTA lugar arma pessoa) = arma
getPessoa (RESPOSTA lugar arma pessoa) = pessoa
let lugares = ["Lavanderia", "Banco" , "Estadio", "Cinema", "Floresta", "Escola", "Igreja", "Shopping", "Praia"]
let armas = ["Machado", "Pa", "Arma quimica", "Revolver", "Faca", "Pe de cabra", "Veneno", "Corda", "Tesoura"]
let pessoas = ["Johann", "Matias", "Clarisse", "Alfred", "Jasmine", "Rosa", "Taylor", "Solomon", "Viktor"]






remove :: String -> [String] -> [String]

remove element list = filter (\e -> e/=element) list
