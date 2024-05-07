import Variables
import Installation
import Partitioning
import System.Process ( callCommand )

main = do
 partitioning
 installation

 putStrLn    "\nRebooting in 5 Seconds..."
 callCommand "sleep 5 && reboot"
