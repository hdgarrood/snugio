{-# LANGUAGE OverloadedStrings #-}

import           Control.Monad
import           Control.Monad.Trans     (liftIO)
import qualified Data.Text.Lazy          as T
import qualified Data.Text.Lazy.Encoding as E
import           Snap.Core
import           Snap.Http.Server

import           Snugio.Core

-- Create a new type of resource, for now, this is a blog post
data Post = Post
     { title   :: String
     , content :: String
     } deriving (Show)

-- Make it a resource
instance Resource Post where
    service_available _ = True
    known_methods _ = ["GET", "POST", "DELETE"]

-- Start
post = Post "Welcome to the webmachine" "Llorum Ipsum..."
t = b13 post "request" "response" []


pong :: Snap ()
pong = method GET $ do
    writeText "pong"

serve :: Config Snap a -> IO()
serve config = httpServe config $ route [
  ("/", pong)
  ]

main :: IO ()
main = serve defaultConfig
