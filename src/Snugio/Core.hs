{-# LANGUAGE OverloadedStrings #-}

module Snugio.Core
  ( Resource(..)
  , b13 ) where

import           Snap.Core

-- Resource containing the defaults when possible and only the type when a
-- custom made function is needed for the Resource
class Resource a where
    serviceAvailable :: a -> Bool
    serviceAvailable _ = True

    knownMethods :: a -> [String]

    resourceHandler :: a -> Snap ()
    resourceHandler _ = writeBS "Welcome to Snugio"

-- All the states on the flow diagram, ordered. The states correspond to the
-- functions below. Currently I manually call the next function, but it would
-- be nice if I could find the next function by looking at the last
-- state. This way I could change the flow by simply changing the `State` data
-- type.
data State = B13 | B12 | B11 deriving (Eq, Ord)

-- Flow is for debugging purposes, so you can see what happened
type Flow = [(State, Bool)]

-- Checks for the availability of the Resource
b13 :: (Resource r) => r -> Request -> Response -> Flow -> String
b13 res req resp flow
    | serviceAvailable res == True = b12 res req resp $ (B13, True) : flow
    | otherwise = "Service is down!"

-- Test if the requested method is already known
b12 :: (Resource r) => r -> Request -> Response -> Flow -> String
b12 res req resp flow = "Service is up"
