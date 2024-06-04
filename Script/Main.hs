import Installation
import System.Process ( callCommand )

main = do
 installation

 putStrLn    "Rebooting in 5 Seconds..."
 callCommand "sleep 5 && reboot"
