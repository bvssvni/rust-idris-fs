module Main

%include C "idrisfs.h"
%link C "idrisfs.o"

getSizeIsize : IO Int
getSizeIsize = foreign FFI_C "sizeof_isize" (IO Int)

main : IO ()
main = do
    x <- getSizeIsize
    putStrLn (show x)
