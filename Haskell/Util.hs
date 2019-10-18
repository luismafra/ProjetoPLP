module Util(
    remove,
    ajeitaPalavra,
    getPalpiteLugar,
    getPalpiteArma,
    getPalpitePessoa
) where

import Data.Char

remove :: (Eq t) => t -> [t] -> [t]
remove elemento lista = filter (/= elemento) lista

ajeitaPalavra :: String -> String
ajeitaPalavra palavra = (map toUpper (take 1 palavra) ) ++ (map toLower (drop 1 palavra))


getPalpiteLugar :: Int -> [String] -> IO String
getPalpiteLugar i lugares
    |i == 1 = return ""
    |otherwise = do
        putStrLn $ "Digite o lugar: "
        palpiteLugar <- getLine
        let aux = ajeitaPalavra palpiteLugar
        if(elem aux lugares) then do
            return aux
        else do
            putStrLn "O lugar inserido é inválido"
            getPalpiteLugar 0 lugares

getPalpiteArma :: Int -> [String] -> IO String
getPalpiteArma i armas
    |i == 1 = return ""
    |otherwise = do
        putStrLn $ "Digite a arma: "
        palpiteArma <- getLine
        let aux = ajeitaPalavra palpiteArma
        if(elem aux armas) then do
            return aux
        else do
            putStrLn "A arma inserida é inválida"
            getPalpiteArma 0 armas


getPalpitePessoa :: Int -> [String] -> IO String
getPalpitePessoa i pessoas
    |i == 1 = return ""
    |otherwise = do
        putStrLn $ "Digite a pessoa: "
        palpitePessoa <- getLine
        let aux = ajeitaPalavra palpitePessoa
        if(elem aux pessoas) then do
            return aux
        else do
            putStrLn "A pessoa inserida é inválida"
            getPalpitePessoa 0 pessoas