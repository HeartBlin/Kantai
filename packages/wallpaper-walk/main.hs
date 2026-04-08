import Control.Exception (SomeException, try)
import Data.Char (ord, toLower)
import Data.List (sort)
import Data.Maybe (fromMaybe)
import System.Directory (getHomeDirectory, listDirectory)
import System.Environment (getArgs)
import System.FilePath (takeExtension, (</>))
import System.IO (IOMode (ReadMode), hGetChar, hGetLine, withBinaryFile, withFile)
import System.Process (callProcess)
import Text.Read (readMaybe)

data Direction = Inc | Dec

main :: IO ()
main = do
  direction <- getArgs >>= parseDirection
  home <- getHomeDirectory
  let dir = home </> "Pictures/Wallpapers"
  wallpapersResult <- readWallpapers dir
  case wallpapersResult of
    Left err -> putStrLn err
    Right wallpapers -> do
      wallpaper <- nextWallpaper direction wallpapers
      setWallpaper (dir </> wallpaper)

stateFile :: FilePath
stateFile = "/tmp/wallpaper_index"

validExtensions :: [String]
validExtensions = [".jpg", ".jpeg", ".png", ".webp"]

isImage :: FilePath -> Bool
isImage = (`elem` validExtensions) . map toLower . takeExtension

readIndex :: IO Int
readIndex = do
  result <- try (withFile stateFile ReadMode hGetLine) :: IO (Either SomeException String)
  return $ either (const 0) (fromMaybe 0 . readMaybe) result

parseDirection :: [String] -> IO Direction
parseDirection ["inc"] = pure Inc
parseDirection ["dec"] = pure Dec
parseDirection _ = do
  putStrLn "Usage: wallpaper-walk [inc|dec]"
  fail "invalid direction"

readWallpapers :: FilePath -> IO (Either String [FilePath])
readWallpapers dir = do
  filesResult <- try (listDirectory dir) :: IO (Either SomeException [FilePath])
  pure $ case filesResult of
    Left _ -> Left ("Could not read directory: " ++ dir)
    Right allFiles ->
      let wallpapers = sort $ filter isImage allFiles
       in if null wallpapers
            then Left "No wallpapers found."
            else Right wallpapers

nextWallpaper :: Direction -> [FilePath] -> IO FilePath
nextWallpaper direction wallpapers = do
  index <- readIndex
  let nextIndex = case direction of
        Inc -> (index + 1) `mod` length wallpapers
        Dec -> (index - 1 + length wallpapers) `mod` length wallpapers
  writeFile stateFile (show nextIndex)
  pure (wallpapers !! nextIndex)

setWallpaper :: FilePath -> IO ()
setWallpaper wallpaperPath =
  callProcess
    "awww"
    [ "img",
      wallpaperPath,
      "--transition-type",
      "random",
      "--transition-step",
      "180",
      "--transition-fps",
      "144"
    ]
