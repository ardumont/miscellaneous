module PropParsers where

import Parsers
import Prop

import String (capitalize)

propConst :: Parser Prop
propConst = do b <- symbol "true" +++
                    symbol "True" +++
                    symbol "False" +++
                    symbol "false"
               let bool = read (capitalize b) :: Bool in
                 return $ Const bool

propVar :: Parser Prop
propVar = do l <- token letter
             return $ Var l

prop :: Parser Prop
prop = propConst +++
         propVar +++
         propNot +++
         propAnd +++
         propOr  +++
         propImply +++
         propEquiv

propNot :: Parser Prop
propNot = do symbol "!"
             a <- prop
             return (Not a)

propAnd :: Parser Prop
propAnd = do symbol "&"
             a <- prop
             b <- prop
             return (And a b)

propOr :: Parser Prop
propOr = do symbol "|"
            a <- prop
            b <- prop
            return (Or a b)

propImply :: Parser Prop
propImply = do symbol "=>"
               a <- prop
               b <- prop
               return (Imply a b)

propEquiv :: Parser Prop
propEquiv = do symbol "<=>"
               a <- prop
               b <- prop
               return (Equiv a b)

propEval :: String -> (Maybe Prop)
propEval s = case parse prop s of
  [(p, "")] -> Just p
  _         -> Nothing

-- *PropParsers> propEval "& a ! b"
-- Just (And (Var 'a') (Not (Var 'b')))
