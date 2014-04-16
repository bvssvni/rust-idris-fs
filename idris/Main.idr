module Main

%include C "idrisfs.h"
%link C "idrisfs.o"

getSizeInt : IO Int
getSizeInt = mkForeign (FFun "sizeof_int" [] FInt)

main : IO ()
main = do
  x <- getSizeInt
  putStrLn (show x)

