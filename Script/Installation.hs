module Installation where

import Variables
import Text.Printf    ( printf )
import System.Process ( callCommand )

installation = do
 putStrLn "\nUpdating Flake..."

 callCommand $ printf "cd /mnt && nix flake update %s %s" 
               linkVonixOS
               hide

 putStrLn "Updating Flake - Successful.\n"
 ---
 putStrLn "(Format: Richard Nixon --> n-richard)"
 putStr   "Name: "

 user <- getLine
 ---
 putStrLn "\nSystem Installation..."

 callCommand $ printf "nixos-install --no-write-lock-file --flake %s#%s"
                      linkVonixOS
                      user

 putStrLn "System Installation - Successful."
