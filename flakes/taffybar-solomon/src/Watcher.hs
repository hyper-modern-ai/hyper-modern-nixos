module Watcher where

import Control.Concurrent.MVar
import Control.Monad
import DBus.Client
import Data.Semigroup ((<>))
import Data.Version (showVersion)
import Options.Applicative
import StatusNotifier.Watcher.Constants
import StatusNotifier.Watcher.Service
import System.Log.DBus.Server
import System.Log.Logger
import Text.Printf

import Paths_status_notifier_item (version)

getWatcherParams :: String -> String -> Priority -> IO WatcherParams
getWatcherParams namespace path priority = do
  logger <- getLogger "StatusNotifier"
  saveGlobalLogger $ setLevel priority logger
  client <- connectSession
  startLogServer client
  return $
    defaultWatcherParams
    { watcherNamespace = namespace
    , watcherPath = path
    , watcherDBusClient = Just client
    }

watcherParamsParser :: Parser (IO WatcherParams)
watcherParamsParser = getWatcherParams
  <$> strOption
  (  long "namespace"
  <> short 'n'
  <> metavar "NAMESPACE"
  <> value "org.kde"
  <> help "The namespace the watcher should register at."
  ) <*> strOption
  (  long "path"
  <> short 'p'
  <> metavar "DBUS-PATH"
  <> value "/StatusNotifierWatcher"
  <> help "The path at which to run the watcher."
  ) <*> option auto
  (  long "log-level"
  <> short 'l'
  <> help "Set the log level"
  <> metavar "LEVEL"
  <> value WARNING
  )

versionOption :: Parser (a -> a)
versionOption = infoOption
                (printf "status-notifier-watcher %s" $ showVersion version)
                (  long "version"
                <> help "Show the version number of gtk-sni-tray"
                )

main :: IO ()
main = do
  watcherParams <- join $ execParser $
                   info (helper <*> versionOption <*> watcherParamsParser)
                   (  fullDesc
                   <> progDesc "Run a StatusNotifierWatcher"
                   )
  stop <- newEmptyMVar
  (_, startWatcher) <- buildWatcher watcherParams { watcherStop = putMVar stop () }
  _ <- startWatcher
  takeMVar stop
