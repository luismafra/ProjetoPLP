import System.Random(randomRIO)
import Control.Monad
import Data.Char


data Tuple = JOGADOR [String] [String] [String] [String] [String] |
             DADOS [String] [String] [String] |
             RESPOSTA String String String

getLugar :: Tuple -> String
getLugar (RESPOSTA lugar arma pessoa) = lugar
getArma :: Tuple -> String
getArma (RESPOSTA lugar arma pessoa) = arma
getPessoa :: Tuple -> String
getPessoa (RESPOSTA lugar arma pessoa) = pessoa

getLugares :: Tuple -> [String]
getLugares (DADOS lugares armas pessoas) = lugares 

getArmas :: Tuple -> [String]
getArmas (DADOS lugares armas pessoas) = armas 

getPessoas :: Tuple -> [String]
getPessoas (DADOS lugares armas pessoas) = pessoas 

remove :: (Eq t) => t -> [t] -> [t]
remove element list = filter (/= element) list

sorteiaResposta :: Tuple -> IO Tuple
sorteiaResposta(DADOS lugares armas pessoas) = do
    x <- randomRIO(0,8::Int)
    y <- randomRIO(0,8::Int)
    z <- randomRIO(0,8::Int)
    let resposta = RESPOSTA (lugares !! x) (armas !! y) (pessoas !! z)
    return resposta

criaBaralho :: Tuple -> Tuple -> [String]
criaBaralho (DADOS lugares armas pessoas) (RESPOSTA lugar arma pessoa) = 
    remove pessoa (remove lugar (remove arma [x | x <- lugares ++ armas ++ pessoas]))

sorteiaCartas :: Int -> [String] -> Tuple -> [String] -> IO (Tuple,[String])    
sorteiaCartas i tudo (DADOS lugares armas pessoas) cartas
    |i == 0 = return (JOGADOR lugares armas pessoas ["", "", ""] cartas, tudo)
    |otherwise = do
        x <- randomRIO(0,((length tudo)-1)::Int)
        let carta = tudo!!x
        let novoArray = remove carta tudo
        if (elem carta lugares) then
            sorteiaCartas (i - 1) novoArray (DADOS (remove carta lugares) armas pessoas) (cartas ++ [carta])
        else if(elem carta armas) then
            sorteiaCartas (i - 1) novoArray (DADOS lugares (remove carta armas) pessoas) (cartas ++ [carta])
        else
            sorteiaCartas (i - 1) novoArray (DADOS lugares armas (remove carta pessoas)) (cartas ++ [carta])

ajeitaPalavra :: String -> String
ajeitaPalavra palavra = (map toUpper (take 1 palavra) ) ++ (map toLower (drop 1 palavra))

verificaResposta :: Tuple -> String -> String -> String -> Bool
verificaResposta (RESPOSTA lugar arma pessoa) palpiteLugar palpiteArma palpitePessoa = (lugar == palpiteLugar && arma == palpiteArma && pessoa == palpitePessoa)

verificaCartas :: [String] -> [String] -> [String]
verificaCartas arrayPalpite cartasBot = 
    [x | x <- arrayPalpite, elem x cartasBot]

vezDoJogador :: Tuple -> Tuple -> IO (Tuple,String)
vezDoJogador (JOGADOR lugares armas pessoas prioridades cartas) (JOGADOR botLugares botArmas botPessoas botPrioridades botCartas) = do
    putStr $ "Digite o lugar: "
    palpiteLugar <- getLine
    let aux = ajeitaPalavra palpiteLugar
    let palpiteLugar = aux
    putStr $ "Digite a arma: "
    palpiteArma <- getLine
    let aux = ajeitaPalavra palpiteArma
    let palpiteArma = aux
    putStr $ "Digite a pessoa: "
    palpitePessoa <- getLine
    let aux = ajeitaPalavra palpitePessoa
    let palpitePessoa = aux
    let botPossui = verificaCartas [palpiteLugar,palpiteArma,palpitePessoa] botCartas
    if((length botPossui) == 0) then
        return (JOGADOR lugares armas pessoas prioridades cartas,"O bot não possui nenhuma das 3 cartas")
    else do
        x <- randomRIO(0,((length botPossui)-1)::Int)
        let retorno = botPossui!!x
        if(elem retorno lugares) then
            return (JOGADOR (remove retorno lugares) armas pessoas prioridades cartas, "O bot tinha " ++ retorno)
        else if(elem retorno armas) then
            return (JOGADOR lugares (remove retorno armas) pessoas prioridades cartas, "O bot tinha " ++ retorno)
        else
            return (JOGADOR lugares armas (remove retorno pessoas) prioridades cartas, "O bot tinha " ++ retorno)

realizaPalpite :: Tuple -> IO (String,Bool)
realizaPalpite resposta = do
    putStr $ "Digite o lugar: "
    palpiteLugar <- getLine
    let aux = ajeitaPalavra palpiteLugar
    let palpiteLugar = aux
    putStr $ "Digite a arma: "
    palpiteArma <- getLine
    let aux = ajeitaPalavra palpiteArma
    let palpiteArma = aux
    putStr $ "Digite a pessoa: "
    palpitePessoa <- getLine
    let aux = ajeitaPalavra palpitePessoa
    let palpitePessoa = aux
    if(verificaResposta resposta palpiteLugar palpiteArma palpitePessoa) then
        return ("PARABÉNS, VOCÊ VENCEU O JOGO!", True)
    else
        return ("VOCÊ ERROU!", False)

start :: Tuple -> Tuple -> Tuple -> Tuple -> String -> IO()
start pessoa bot1 bot2 resposta opcao
    |opcao == "5" = putStrLn "FIM DE JOGO"
    |otherwise = do
        mostraMenu pessoa
        opcao <- getLine   
        if opcao == "1" then do
            aux <- vezDoJogador pessoa bot1
            let pessoa = fst aux
            putStrLn (snd aux)
            start pessoa bot1 bot2 resposta opcao
        else if opcao == "2" then do
            aux <- vezDoJogador pessoa bot2
            let pessoa = fst aux
            putStrLn (snd aux)
            start pessoa bot1 bot2 resposta opcao
        else if opcao == "3" then do
            aux <- realizaPalpite resposta
            if(snd aux) then do
                putStrLn (fst aux)
            else do
                putStrLn (fst aux)
                start pessoa bot1 bot2 resposta opcao
        else if opcao == "4" then do
            mostraCartasJogador pessoa
            start pessoa bot1 bot2 resposta opcao
        else if opcao == "5" then do
            start pessoa bot1 bot2 resposta opcao
        else do
            putStrLn ("OPCAO INVALIDA")
            start pessoa bot1 bot2 resposta opcao

mostraCartasJogador :: Tuple -> IO ()
mostraCartasJogador (JOGADOR lugares armas pessoas prioridades cartas) = do
    print cartas

mostraPossiveis :: Tuple -> IO()
mostraPossiveis (JOGADOR lugares armas pessoas prioridades cartas) = do
    putStrLn $ "POSSIBILIDADES DE LUGARES PARA O JOGADOR:"
    print $ lugares
    putStrLn $ "POSSIBILIDADES DE ARMAS PARA O JOGADOR:"
    print $ armas
    putStrLn $ "POSSIBILIDADES DE PESSOAS PARA O JOGADOR:"
    print $ pessoas

mostraMenu :: Tuple -> IO ()
mostraMenu pessoa = do
    putStrLn $ "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
    putStrLn $ "-=-=                          Sua vez de jogar ...                           =-=-" 
    putStrLn $ "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
    putStrLn $ "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
    mostraPossiveis pessoa
    putStrLn $ "Escolha uma opcao"
    putStrLn $ "1 - Perguntar ao bot1"
    putStrLn $ "2 - Perguntar ao bot2"
    putStrLn $ "3 - Dar um palpite"
    putStrLn $ "4 - Para olhar suas cartas"
    putStrLn $ "5 - Sair"
    putStr $ "Opcao> "

main = do 
    let lugares = ["Lavanderia", "Banco" , "Estadio", "Cinema", "Floresta", "Escola", "Igreja", "Shopping", "Praia"]
    let armas = ["Machado", "Pa", "Arma quimica", "Revolver", "Faca", "Pe de cabra", "Veneno", "Corda", "Tesoura"]
    let pessoas = ["Johann", "Matias", "Clarisse", "Alfred", "Jasmine", "Rosa", "Taylor", "Solomon", "Viktor"]
    let prioridades = ["", "", ""]

    let base = DADOS lugares armas pessoas
    let pessoa = JOGADOR lugares armas pessoas prioridades []
    let bot1 = JOGADOR lugares armas pessoas prioridades []
    let bot2 = JOGADOR lugares armas pessoas prioridades []
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

    start pessoa bot1 bot2 resposta "0"