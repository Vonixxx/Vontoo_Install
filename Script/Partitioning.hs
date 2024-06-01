module Partitioning where

import Variables
import Text.Printf    ( printf )
import System.Process ( callCommand )

partitioning = do
 putStrLn "\nAcquiring Partitioning Module..."

 callCommand $ printf "cp %s /tmp/partitioning.nix %s"
                      linkDiskSetup
                      hide

 putStrLn "Acquiring Partitioning Module - Successful."
 ---
 callCommand "lsblk --nodeps --output NAME,SIZE"

 putStrLn "Pick the disk largest in size."
 putStrLn "Type in: sda OR nvme0n1, depending on the list."
 putStr   "Disk: "

 disk <- getLine
 ---
 putStrLn "\nPartitioning..."

 callCommand $ printf "nix run %s -- --mode disko /tmp/partitioning.nix --arg device '\"/dev/%s\"' %s"
                      linkDisko
                      disk
                      hide

 putStrLn "Partitioning - Successful."
