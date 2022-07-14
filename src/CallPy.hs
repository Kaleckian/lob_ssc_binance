module CallPy where

import System.Process (
  runCommand,
  system,
  runInteractiveProcess,
  ProcessHandle )

import GHC.IO.Exception ( ExitCode )
import qualified GHC.IO.Handle as GHC.IO.Handle.Types
import MyLib (DataOB (_idUpdate, midP, wgmidP, cjpM, regOLS, dataOLS))
--activateEnv = system "py_haskell/Scripts/activate"

--activateEnv = rawSystem $ "venv/Scripts/activate" [] []

initData :: IO ExitCode
initData = system $ "python py_files/initData.py"

livePlots :: IO ExitCode
livePlots = system $ "python py_files/livePlots.py"


argData :: DataOB -> IO ExitCode
argData df_ob = system $ "python py_files/argData.py" ++ " " ++
  show(MyLib._idUpdate df_ob) ++ " " ++
  show(MyLib.midP df_ob) ++ " " ++
  show(MyLib.wgmidP df_ob) ++ " " ++
  show(MyLib.cjpM df_ob) ++ " " ++
  show(fst $ MyLib.regOLS df_ob) ++ " " ++
  show(MyLib.dataOLS df_ob)

--system $ "start " ++ "\"venv/Scripts/activate.bat\""
--test2 = system $ "pythonw tmp/fatorial.py" ++ " 5"
--test2 = system $ "pythonw py_files/background.py"
--test2 = system $ "pythonw tmp/fatorial.py" ++ " 5"
{-
staticPy :: IO ExitCode
staticPy = do
  test2
-}
--   runCommand $ "venv/Scripts/python.exe"

  --runInteractiveProcess "venv/Scripts/ipython3.exe"
  -- system $ "Powershell.exe -executionpolicy remotesigned" ++ 
  --   " -File  \"venv/Scripts/activate.ps1\"" 



-- ++ " & python py_files/static.py"
--system $ "python py_files/static.py"

