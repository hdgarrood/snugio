module Snugio.Core () where

-- Resource containing the defaults when possible and only the type when a
-- custom made function is needed for the Resource
class Resource a where
    service_available :: a -> Bool
    service_available _ = True
    
    known_methods :: a -> [String]

-- For now, fake the Request and Response types, this will be replaced by Snap
-- in the future.
type Request = String
type Response = String

-- All the states on the flow diagram, ordered. The states correspond to the
-- functions below. Currently I manually call the next function, but it would
-- be nice if I could find the next function by looking at the last
-- state. This way I could change the flow by simply changing the `State` data
-- type.
data State = B13 | B12 | B11 deriving (Eq, Ord)

-- Flow is for debugging purposes, so you can see what happened
type Flow = [(State, Bool)]

-- Checks for the availability of the Resource
b13 :: (Resource r) => r -> Request -> Response -> Flow -> Response
b13 res req resp flow 
    | service_available res == True = b12 res req resp $ (B13, True) : flow
    | otherwise = "Service is down!"

-- Test if the requested method is already known
b12 :: (Resource r) => r -> Request -> Response -> Flow -> Response
b12 res req resp flow = "Service is up"

-- Let's put the above to the test
-- Create a new type of resource, for now, this is a blog post
data Post = Post
     { title :: String
     , content :: String
     } deriving (Show)

-- Make it a resource
instance Resource Post where
    service_available _ = True
    known_methods _ = ["GET", "POST", "DELETE"]
    
-- Start 
post = Post "Welcome to the webmachine" "Llorum Ipsum..."
t = b13 post "request" "response" []