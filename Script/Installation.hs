module Installation where

import Text.Printf    ( printf )
import System.Process ( callCommand )

vontoo = "github:Vonixxx/Vontoo"
disko  = "github:nix-community/disko#disko-install"

installation = do
 callCommand "\nlsblk --nodeps --output NAME,SIZE"

 putStrLn "Pick the largest in size."
 putStrLn "Either 'sda' or 'nvme0n1'"
 putStr   "Disk: "

 disk <- getLine
---
 callCommand "\nnix flake show github:Vonixxx/Vontoo"

 putStrLn "Input your name as seen in the list. (Format: Richard Nixon --> N_Richard)"
 putStr   "Name: "

 user <- getLine
---
 putStrLn "\nSystem Installation...\n"

 callCommand $ printf "nix run '%s' -- --dry-run --flake '%s#%s' --mode format --disk main /dev/%s --write-efi-boot-entries"
                      disko
                      vontoo
                      user
                      disk

 putStrLn "\nSystem Installation - Successful."
