module Audio.WebAudio.AudioBuffer.Raw (
  mkAudioBuffer
--TODO:, unsafeCopyFromChannel
) where

import Audio.WebAudio.Types (AudioBuffer)
import Control.Monad.Eff.Exception (Error)
import Data.Either (Either(..))
import Data.Function.Uncurried (Fn3, runFn3)
import Data.Maybe (Maybe(..))

type AudioBufferOptions = {
  length :: Int
, numberOfChannels :: Maybe Int
, sampleRate :: Int
}

mkAudioBuffer :: AudioBufferOptions -> Either Error AudioBuffer
mkAudioBuffer opts = case opts.numberOfChannels of
  Nothing -> runFn3 mkAudioBufferImpl Left Right {
    length: opts.length
  , sampleRate: opts.sampleRate
  }
  Just i -> runFn3 mkAudioBufferImpl Left Right {
    length: opts.length
  , sampleRate: opts.sampleRate
  , numberOfChannels: i
  }

foreign import mkAudioBufferImpl
  :: forall r
   . Fn3 (String -> Either String AudioBuffer)
         (AudioBuffer -> Either String AudioBuffer) 
         { length :: Int, sampleRate :: Int | r }
         (Either Error AudioBuffer)
