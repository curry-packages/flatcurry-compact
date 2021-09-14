------------------------------------------------------------------------------
--- A tool to reduce the size of FlatCurry programs by replacing
--- the main FlatCurry file by a single FlatCurry file containing
--- no imports but all imported and potentially called functions.
---
--- @author Michael Hanus
--- @version September 2021
------------------------------------------------------------------------------

import Data.List          ( intersperse )
import System.Environment ( getArgs )

import FlatCurry.Types
import FlatCurry.Files
import FlatCurry.Compact
import System.CurryPath   ( runModuleAction )
import System.Process     ( system )

-- Check arguments and call main function:
main :: IO ()
main = do
  args <- getArgs
  case args of
    ["-h"]                -> putStrLn usage
    ["--help"]            -> putStrLn usage
    ["--export",mname]    -> compactProgAndReplace [Exports] mname
    ["--main",func,mname] -> compactProgAndReplace [Main func] mname
    [mname]               -> compactProgAndReplace [] mname
    _                     -> putStrLn $ useError args
 where
  useError args = "ERROR: Illegal arguments: " ++ unwords args ++ "\n" ++ usage

  usage = "Usage: curry-compactflat [--export | --main func] <module_name>"

-- replace a FlatCurry program by a compactified version:
compactProgAndReplace :: [Option] -> String -> IO ()
compactProgAndReplace options = runModuleAction compact
 where
  compact mname = do
    generateCompactFlatCurryFile (Required defaultRequired : options)
                                 mname (mname ++ "_comp.fcy")
    let fcyname = flatCurryFileName mname
    system $ "mv " ++ mname ++ "_comp.fcy " ++ fcyname
    putStrLn $
      "curry-compactflat: compacted program '" ++ fcyname ++ "' written."

