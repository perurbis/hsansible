{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
-- |
-- Module:       $HEADER$
-- Description:  Simple Ansible-style failure message.
-- Copyright:    (c) 2013 Peter Trsko
-- License:      BSD3
--
-- Maintainer:   peter.trsko@gmail.com
-- Stability:    experimental
-- Portability:  non-portable (OverloadedStrings, RecordWildCards)
--
-- 'Failure' message type can be used directly in 'ErrorT' monad transformer,
-- thanks to its 'Error' instance, and also serialized to JSON and sent to
-- Ansible master as a result.
module Ansible.Failure
    ( Failure
    , mkFailure
    )
    where

import qualified Control.Monad.Trans.Error as E
import Data.Aeson (ToJSON, (.=))
import qualified Data.Aeson as JSON


-- | Constructor is hidden intentionally, use 'mkFailure' or 'Error' instance
-- instead.
data Failure = Failure {failed :: Bool, msg :: String}

-- | Construct a 'Failure' given a error/failure message.
mkFailure :: String -> Failure
mkFailure msg = Failure{failed = True, msg = msg}

instance E.Error Failure where
    noMsg = mkFailure ""
    strMsg = mkFailure

-- | Prints the message prefixed with "Failure: ".
instance Show Failure where
    showsPrec _ Failure{..} = showString "Failure: " . showString msg

instance ToJSON Failure where
    toJSON Failure{..} = JSON.object
        [ "failed" .= failed
        , "msg" .= msg
        ]
