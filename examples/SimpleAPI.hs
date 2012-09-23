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
    serviceAvailable _ = True
    knownMethods _ = ["GET", "POST", "DELETE"]

    resourceHandler _ = writeText "Welcome to Snugio"

-- Start
post = Post "Welcome to the webmachine" "Llorum Ipsum..."

serve :: Config Snap a -> IO ()
serve config = httpServe config $ route [
      ("/", resourceHandler post)
      ]

main :: IO ()
main = serve defaultConfig
