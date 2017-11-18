module Audio.WebAudio.AudioBuffer (
--  mkAudioBuffer
  sampleRate
, length
, duration
, numberOfChannels
, getChannelData
--TODO: , copyToChannel
, module Audio.WebAudio.Types
) where

import Audio.WebAudio.Types (AudioBuffer)
import Data.ArrayBuffer.Types (Float32Array)
import Data.Function.Uncurried (Fn4, runFn4)
import Data.Maybe (Maybe(..))

--mkAudioBuffer :: Data -> AudioBuffer

foreign import sampleRate :: AudioBuffer -> Number

foreign import length :: AudioBuffer -> Int

foreign import duration :: AudioBuffer -> Number

foreign import numberOfChannels :: AudioBuffer -> Int

getChannelData :: AudioBuffer -> Int -> Maybe Float32Array
getChannelData = runFn4 getChannelDataImp Just Nothing

foreign import getChannelDataImp :: Fn4 (Float32Array -> Maybe Float32Array) (Maybe Float32Array) AudioBuffer Int (Maybe Float32Array)
