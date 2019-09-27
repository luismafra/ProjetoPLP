data Tuple = JOGADOR [String] [String] [String] [String] [String] |
             DADOS [String] [String] [String] |
             RESPOSTA String String String

getLugar :: Tuple -> String
getPessoa :: Tuple -> String
getArma :: Tuple -> String
getLugar (RESPOSTA a b c) = b
getArma (RESPOSTA a b c) = a
getPessoa (RESPOSTA a b c) = c

remove :: String -> [String] -> [String]

remove element list = filter (\e -> e/=element) list
