module Lib
    ( run
    ) where

-- import qualified Control.Foldl as Fold
import           Control.Exception
import qualified Data.Text         as Text
import qualified Data.Text.IO      as Text
import           Hosts             (hosts)
import           Turtle
import           Turtle.Line

gitRemotes host = Fold (mkRemote host) [] id
  where
    getPath t = case Text.findIndex (=='\t') t of
      Nothing -> Nothing
      Just i  -> Just $ snd $ Text.splitAt (i+1) t
    mkRemote :: Text -> [Text] -> Either Line Line -> [Text]
    mkRemote host remotes entry =
      case entry of
        Right e ->
          case getPath $ lineToText e of
            Just p -> remotes ++ [host <> ":" <> p]
            _      -> remotes
        Left e -> remotes ++ [lineToText e]

gitList host = do
  let stdout = inprocWithErr "ssh" ["-T", host] empty
  mapM_ Text.putStrLn =<< fold stdout (gitRemotes host)

catchExitCode = handle withExitCode
  where
    withExitCode (ExitFailure _) = return ()

run :: IO ()
run =
  mapM_ (catchExitCode . gitList) hosts
