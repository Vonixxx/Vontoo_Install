module Installation where

import Variables
import Text.Printf    ( printf )
import System.Process ( callCommand )

installation = do
 putStrLn "Input your name. (Format: Richard Nixon --> n-richard)"
 putStr   "Name: "

 user <- getLine
 ---
 putStrLn "\nSystem Installation..."

 callCommand $ printf "cd /mnt && nix-shell -p nixVersions.latest --run 'nixos-install --flake github:Vonixxx/Vontoo#%s"
                      user

 putStrLn "System Installation - Successful."
