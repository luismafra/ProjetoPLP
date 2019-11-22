module GameFunctions(
    sorteiaResposta,
    sorteiaCartas,
    criaBaralho,
    start
) where


import Control.Monad
import System.Random(randomRIO)

-- Comando para instalar o package Random: cabal update
-- Comando para instalar o package Random: cabal install Random

import Util
import Structs


sorteiaResposta :: Tuple -> IO Tuple
sorteiaResposta(DADOS lugares armas pessoas) = do
    x <- randomRIO(0, 8::Int)
    y <- randomRIO(0, 8::Int)
    z <- randomRIO(0, 8::Int)
    let resposta = RESPOSTA (lugares !! x) (armas !! y) (pessoas !! z)
    return resposta

criaBaralho :: Tuple -> Tuple -> [String]
criaBaralho (DADOS lugares armas pessoas) (RESPOSTA lugar arma pessoa) = 
    remove pessoa (remove lugar (remove arma [x | x <- lugares ++ armas ++ pessoas]))

sorteiaCartas :: Int -> [String] -> Tuple -> [String] -> IO (Tuple,[String])    
sorteiaCartas i tudo (DADOS lugares armas pessoas) cartas
    |i == 0 = return (JOGADOR lugares armas pessoas ["", "", ""] cartas 0, tudo)
    |otherwise = do
        x <- randomRIO(0,((length tudo)-1)::Int)
        let carta = tudo !! x
        let novoArray = remove carta tudo
        if (elem carta lugares) then
            sorteiaCartas (i - 1) novoArray (DADOS (remove carta lugares) armas pessoas) (cartas ++ [carta])
        else if(elem carta armas) then
            sorteiaCartas (i - 1) novoArray (DADOS lugares (remove carta armas) pessoas) (cartas ++ [carta])
        else
            sorteiaCartas (i - 1) novoArray (DADOS lugares armas (remove carta pessoas)) (cartas ++ [carta])

verificaResposta :: Tuple -> String -> String -> String -> Bool
verificaResposta (RESPOSTA lugar arma pessoa) palpiteLugar palpiteArma palpitePessoa = (lugar == palpiteLugar && arma == palpiteArma && pessoa == palpitePessoa)

verificaCartas :: [String] -> [String] -> [String]
verificaCartas arrayPalpite cartasBot = 
    [x | x <- arrayPalpite, elem x cartasBot]

vezDoJogador :: Tuple -> Tuple -> Tuple -> IO (Tuple, String)
vezDoJogador (JOGADOR lugares armas pessoas prioridades cartas countPrioridade) (JOGADOR botLugares botArmas botPessoas botPrioridades botCartas countPrioridadeBot) (DADOS baseLugares baseArmas basePessoas) = do
    palpiteLugar <- getPalpiteLugar 0 baseLugares
    palpiteArma <- getPalpiteArma 0 baseArmas
    palpitePessoa <- getPalpitePessoa 0 basePessoas
    let botPossui = verificaCartas [palpiteLugar,palpiteArma,palpitePessoa] botCartas
    if((length botPossui) == 0) then
        return (JOGADOR lugares armas pessoas prioridades cartas 0,"O bot nao possui nenhuma das 3 cartas")
    else do
        x <- randomRIO(0,((length botPossui)-1)::Int)
        let retorno = botPossui!!x
        if(elem retorno lugares) then
            return (JOGADOR (remove retorno lugares) armas pessoas prioridades cartas 0, "O bot tinha " ++ retorno)
        else if(elem retorno armas) then
            return (JOGADOR lugares (remove retorno armas) pessoas prioridades cartas 0, "O bot tinha " ++ retorno)
        else
            return (JOGADOR lugares armas (remove retorno pessoas) prioridades cartas 0, "O bot tinha " ++ retorno)            


vezDoBot :: String -> Tuple -> Tuple -> Tuple -> Tuple -> IO (Tuple, String)
vezDoBot nome (JOGADOR botRodadaLugares botRodadaArmas botRodadaPessoas botRodadaPrioridades botRodadaCartas countPrioridade) (JOGADOR botLugares botArmas botPessoas botPrioridades botCartas x) (JOGADOR lugares armas pessoas prioridades cartas y) resposta = do  
    if((length botRodadaArmas == 1 && length botRodadaLugares == 1 && length botRodadaPessoas == 1) || countPrioridade == 3) then
        return (JOGADOR botRodadaLugares botRodadaArmas botRodadaPessoas botRodadaPrioridades botRodadaCartas countPrioridade, "WIN")
    else do
        chance <- randomRIO (1,10 :: Int)
        if(countPrioridade > 0 && chance > 7) then
            if(verificaResposta resposta (botRodadaPrioridades!!0) (botRodadaPrioridades!!1) (botRodadaPrioridades!!2)) then
                return (JOGADOR botRodadaLugares botRodadaArmas botRodadaPessoas botRodadaPrioridades botRodadaCartas countPrioridade, "WIN")
            else
                return (JOGADOR botRodadaLugares botRodadaArmas botRodadaPessoas botRodadaPrioridades botRodadaCartas 0, "O " ++ nome ++ " tentou chutar e errou.")
        else do
            aux <-
                if(countPrioridade == 0) then do
                    x <- randomRIO (0,1 :: Int)
                    return x
                else if(countPrioridade == 1) then do
                    x <- randomRIO (1,1 :: Int)
                    return x
                else do
                    x <- randomRIO (0,0 :: Int)
                    return x
            
            palpiteLugar <- 
                if(countPrioridade /= 0) then do
                    x <- randomRIO(0,0 :: Int)
                    let r = botRodadaPrioridades !! x
                    return r
                else do
                    x <- randomRIO (0, (length botRodadaLugares) - 1 :: Int)
                    let r = botRodadaLugares !! x
                    return r
            palpiteArma <- 
                if(countPrioridade /= 0) then do
                    x <- randomRIO(1,1 :: Int)
                    let r = botRodadaPrioridades !! x
                    return r
                else do
                    x <- randomRIO (0, (length botRodadaArmas) - 1 :: Int)
                    let r = botRodadaArmas !! x
                    return r
            palpitePessoa <- 
                if(countPrioridade /= 0) then do
                    x <- randomRIO(2,2 :: Int)
                    let r = botRodadaPrioridades !! x
                    return r
                else do
                    x <- randomRIO (0, (length botRodadaPessoas) - 1 :: Int)
                    let r = botRodadaPessoas !! x
                    return r
            
            if(aux == 0) then do
                let botPossui = verificaCartas [palpiteLugar, palpiteArma, palpitePessoa] botCartas
                w <- (randomRIO (0, (length botPossui) - 1 :: Int))
                let removido = botPossui !! w
                if (length botPossui) > 0 then
                    if (elem removido botRodadaLugares) then
                        return (JOGADOR (remove removido botRodadaLugares) botRodadaArmas botRodadaPessoas botRodadaPrioridades botRodadaCartas 0, "O " ++ nome ++ " jogou.")
                    else if (elem removido botRodadaArmas) then
                        return (JOGADOR botRodadaLugares (remove removido botRodadaArmas) botRodadaPessoas botRodadaPrioridades botRodadaCartas 0, "O " ++ nome ++ " jogou.")
                    else do
                        return (JOGADOR botRodadaLugares botRodadaArmas (remove removido botRodadaPessoas) botRodadaPrioridades botRodadaCartas 0, "O " ++ nome ++ " jogou.")
                else
                    if(countPrioridade == 0) then
                        return (JOGADOR botRodadaLugares botRodadaArmas botRodadaPessoas [palpiteLugar,palpiteArma,palpitePessoa] botRodadaCartas 1, "O " ++ nome ++ " jogou.")
                    else
                        return (JOGADOR botRodadaLugares botRodadaArmas botRodadaPessoas [palpiteLugar,palpiteArma,palpitePessoa] botRodadaCartas 3, "O " ++ nome ++ " jogou.")
            else do
                let jogadorPossui = verificaCartas [palpiteLugar, palpiteArma, palpitePessoa] cartas
                putStrLn "A pergunta do bot para voce foi:" 
                putStrLn $ "Lugar: " ++ palpiteLugar
                putStrLn $ "Arma: " ++ palpiteArma
                putStrLn $ "Pessoa: " ++ palpitePessoa
                if(length jogadorPossui == 0) then do
                    print "Voce nao possui nenhuma carta."
                    if(countPrioridade == 0) then
                        return (JOGADOR botRodadaLugares botRodadaArmas botRodadaPessoas [palpiteLugar,palpiteArma,palpitePessoa] botRodadaCartas 2, "O " ++ nome ++ " jogou.")
                    else
                        return (JOGADOR botRodadaLugares botRodadaArmas botRodadaPessoas [palpiteLugar,palpiteArma,palpitePessoa] botRodadaCartas 3, "O " ++ nome ++ " jogou.")
                else do
                    removido <- jogadorResponde 0 jogadorPossui
                    if (elem removido botRodadaLugares) then
                        return (JOGADOR (remove removido botRodadaLugares) botRodadaArmas botRodadaPessoas botRodadaPrioridades botRodadaCartas 0, "O " ++ nome ++ " jogou.")
                    else if (elem removido botRodadaArmas) then
                        return (JOGADOR botRodadaLugares (remove removido botRodadaArmas) botRodadaPessoas botRodadaPrioridades botRodadaCartas 0, "O " ++ nome ++ " jogou.")
                    else do
                        return (JOGADOR botRodadaLugares botRodadaArmas (remove removido botRodadaPessoas) botRodadaPrioridades botRodadaCartas 0, "O " ++ nome ++ " jogou.")

realizaPalpite :: Tuple -> Tuple -> IO (String, Bool)
realizaPalpite resposta  (DADOS baseLugares baseArmas basePessoas) = do
    palpiteLugar <- getPalpiteLugar 0 baseLugares
    palpiteArma <- getPalpiteArma 0 baseArmas
    palpitePessoa <- getPalpitePessoa 0 basePessoas
    if(verificaResposta resposta palpiteLugar palpiteArma palpitePessoa) then
        return ("PARABENS, VOCE VENCEU O JOGO!, " ++  palpitePessoa ++ " matou com um(a) " ++  palpiteArma ++ " no(a) " ++ palpiteLugar,  True)
    else
        return ("VOCE ERROU!", False)


jogadorResponde :: Int -> [String] -> IO String
jogadorResponde i jogadorPossui
    |i == 1 = return ""
    |otherwise = do
        putStrLn "Voce possui: "
        print $ jogadorPossui
        putStr "Qual voce quer que ele saiba? "
        resposta <- getLine
        let aux = ajeitaPalavra resposta
        let resposta = aux
        if(elem resposta jogadorPossui) then do
            return resposta
        else do
            putStrLn "Essa nao e uma das opcoes"
            jogadorResponde 0 jogadorPossui


imprimeResposta :: Tuple -> IO()
imprimeResposta (RESPOSTA lugar arma pessoa) = do
    putStrLn $ pessoa ++ " matou com um(a) " ++  arma ++ " no(a) " ++ lugar
            

start :: Tuple -> Tuple -> Tuple -> Tuple -> Tuple -> String -> IO()
start pessoa bot1 bot2 resposta base opcao
    |opcao == "5" = putStrLn "FIM DE JOGO"
    |otherwise = do
        mostraMenu pessoa
        opcao <- getLine
        if opcao == "1" then do
            aux <- vezDoJogador pessoa bot1 base
            let pessoa = fst aux
            putStrLn (snd aux)
            putStrLn ""
            aux <- vezDoBot "bot1" bot1 bot2 pessoa resposta
            let bot1 = fst aux
            if(snd aux == "WIN") then do     
                putStrLn "O BOT 1 VENCEU O JOGO!!!!" 
                imprimeResposta resposta
            else do
                putStrLn (snd aux)
                putStrLn ""
                aux <- vezDoBot "bot2" bot2 bot1 pessoa resposta
                let bot2 = fst aux
                if(snd aux == "WIN") then do
                    putStrLn "O BOT 2 VENCEU O JOGO!!!!"
                    imprimeResposta resposta
                else do
                    putStrLn (snd aux)
                    putStrLn ""
                    start pessoa bot1 bot2 resposta base opcao
        else if opcao == "2" then do
            aux <- vezDoJogador pessoa bot2 base
            let pessoa = fst aux
            putStrLn (snd aux)
            putStrLn ""
            aux <- vezDoBot "bot1" bot1 bot2 pessoa resposta
            let bot1 = fst aux
            if(snd aux == "WIN") then do
                putStrLn "O BOT 1 VENCEU O JOGO!!!! "
                imprimeResposta resposta
            else do
                putStrLn (snd aux)
                putStrLn ""
                aux <- vezDoBot "bot2" bot2 bot1 pessoa resposta
                let bot2 = fst aux
                if(snd aux == "WIN") then do
                    putStrLn "O BOT 2 VENCEU O JOGO!!!!"
                    imprimeResposta resposta
                else do
                    putStrLn (snd aux)
                    putStrLn ""
                    start pessoa bot1 bot2 resposta base opcao
        else if opcao == "3" then do
            aux <- realizaPalpite resposta base
            if(snd aux) then do
                putStrLn (fst aux)
            else do
                putStrLn (fst aux)
                putStrLn ""
                aux <- vezDoBot "bot1" bot1 bot2 pessoa resposta
                let bot1 = fst aux
                if(snd aux == "WIN") then do
                    putStrLn "O BOT 1 VENCEU O JOGO!!!!"
                    imprimeResposta resposta
                else do
                    putStrLn (snd aux)
                    putStrLn ""
                    aux <- vezDoBot "bot2" bot2 bot1 pessoa resposta
                    let bot2 = fst aux
                    if(snd aux == "WIN") then do
                        putStrLn "O BOT 2 VENCEU O JOGO!!!!"
                        imprimeResposta resposta
                    else do
                        putStrLn (snd aux)
                        putStrLn ""
                        start pessoa bot1 bot2 resposta base opcao
        else if opcao == "4" then do
            mostraCartasJogador pessoa
            start pessoa bot1 bot2 resposta base opcao
        else if opcao == "5" then do
            start pessoa bot1 bot2 resposta base opcao
        else do
            putStrLn ("OPCAO INVALIDA")
            start pessoa bot1 bot2 resposta base opcao

mostraCartasJogador :: Tuple -> IO ()
mostraCartasJogador (JOGADOR lugares armas pessoas prioridades cartas count) = do
    print cartas

mostraPossiveis :: Tuple -> IO()
mostraPossiveis (JOGADOR lugares armas pessoas prioridades cartas count) = do
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
    putStrLn $ "4 - Olhar suas cartas"
    putStrLn $ "5 - Sair"
    putStrLn $ "Opcao> "