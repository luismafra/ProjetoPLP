import System.Random(randomRIO) 


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
sorteiaResposta :: Tuple -> IO Tuple
criaBaralho :: Tuple -> Tuple -> IO [String]

getLugar (RESPOSTA lugar arma pessoa) = lugar
getArma (RESPOSTA lugar arma pessoa) = arma
getPessoa (RESPOSTA lugar arma pessoa) = pessoa

getLugares (DADOS lugares armas pessoas) = lugares 
getArmas (DADOS lugares armas pessoas) = armas 
getPessoas (DADOS lugares armas pessoas) = pessoas 

remove element list = filter (/=element) list
sorteiaResposta(DADOS lugares armas pessoas) = do
    x <- randomRIO(0,8::Int)
    y <- randomRIO(0,8::Int)
    z <- randomRIO(0,8::Int)
    let resposta = RESPOSTA (lugares!!x) (armas!!y) (pessoas!!z)
    return resposta

criaBaralho (DADOS lugares armas pessoas) (RESPOSTA lugar arma pessoa) = do
    let tudo = lugares ++ armas ++ pessoas
    let tudo2 = remove lugar tudo
    let tudo3 = remove arma tudo2
    let tudo4 = remove pessoa tudo3
    return tudo4



main = do 
    let lugares = ["Lavanderia", "Banco" , "Estadio", "Cinema", "Floresta", "Escola", "Igreja", "Shopping", "Praia"]
    let armas = ["Machado", "Pa", "Arma quimica", "Revolver", "Faca", "Pe de cabra", "Veneno", "Corda", "Tesoura"]
    let pessoas = ["Johann", "Matias", "Clarisse", "Alfred", "Jasmine", "Rosa", "Taylor", "Solomon", "Viktor"]
    let prioridades = ["", "", ""]
    let cartas = []

    let base = DADOS lugares armas pessoas
    let pessoa = JOGADOR lugares armas pessoas prioridades cartas
    let bot1 = JOGADOR lugares armas pessoas prioridades cartas
    let bot2 = JOGADOR lugares armas pessoas prioridades cartas
    resposta <- sorteiaResposta base
    baralho <- criaBaralho base resposta
    print(getArma resposta)
    print(getLugar resposta)
    print(getPessoa resposta)
    putStrLn $ show baralho




