-- | This module provides helper functions for converting replays to and from
-- both their binary format and JSON.
module Rattletrap.Utility.Helper
  ( decodeReplayFile
  , encodeReplayJson
  , decodeReplayJson
  , encodeReplayFile
  )
where

import Rattletrap.Decode.Common
import Rattletrap.Encode.Content
import Rattletrap.Decode.Replay
import Rattletrap.Encode.Replay
import Rattletrap.Type.Replay
import Rattletrap.Type.Section
import Rattletrap.Type.Content

import qualified Data.Aeson as Json
import qualified Data.Aeson.Encode.Pretty as Json
import qualified Data.Binary.Put as Binary
import qualified Data.ByteString as Bytes
import qualified Data.ByteString.Lazy as LazyBytes

-- | Parses a raw replay.
decodeReplayFile :: Bool -> Bytes.ByteString -> Either String Replay
decodeReplayFile fast = runDecode $ decodeReplay fast

-- | Encodes a replay as JSON.
encodeReplayJson :: Replay -> Bytes.ByteString
encodeReplayJson = LazyBytes.toStrict . Json.encodePretty' Json.defConfig
  { Json.confCompare = compare
  , Json.confIndent = Json.Spaces 2
  , Json.confTrailingNewline = True
  }

-- | Parses a JSON replay.
decodeReplayJson :: Bytes.ByteString -> Either String Replay
decodeReplayJson = Json.eitherDecodeStrict'

-- | Encodes a raw replay.
encodeReplayFile :: Bool -> Replay -> Bytes.ByteString
encodeReplayFile fast replay =
  LazyBytes.toStrict . Binary.runPut . putReplay $ if fast
    then replay { replayContent = toSection putContent defaultContent }
    else replay
