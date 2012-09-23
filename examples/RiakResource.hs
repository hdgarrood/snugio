{-# LANGUAGE OverloadedStrings #-}

import           Control.Applicative        ((<$>))
import           Control.Monad              (mzero)
import           Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as L
import           Data.Text                  (Text)
import           Network.Riak
import           Snap.Core
import           Snap.Http.Server

-- create a new datatype which is a message
data Msg = Msg Text deriving (Show)

-- Make it an instance which can be converted from JSON, with the possibility
-- of failure.
instance FromJSON Msg where
  parseJSON (Object v) = Msg <$> v .: "message"
  parseJSON _ = mzero

-- Also make it an instance which can be converted to JSON.
instance ToJSON Msg where
  toJSON (Msg s) = object [ "message" .= s]

-- Make it an instance of resolvable
instance Resolvable Msg

-- create a new msg
msg = Msg "Welcome to a brave new world."

serve :: Config Snap a -> IO ()
serve config = httpServe config $ route [
      ("/", writeBS "Hello")
      ]

myClient :: Client
myClient = Client {
         host = "127.0.0.1"
              , port = "8081"
              , clientID = L.empty
         }

main :: IO ()
main = do
     -- connect to riak
     conn <- connect myClient

     -- add a msg to the database
     new_msg <- put conn "messages" "abc" Nothing msg One One
     serve defaultConfig
