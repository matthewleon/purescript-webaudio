module Audio.WebAudio.AudioBuffer (
  mkAudioBuffer
, sampleRate
, length
, duration
, numberOfChannels
, getChannelData
--, copyFromChannel
, module Audio.WebAudio.Types
) where

import Prelude

import Audio.WebAudio.AudioBuffer.ST (copyToChannel, mkSTAudioBuffer, unsafeFreeze)
import Audio.WebAudio.Types (AudioBuffer)
import Control.Monad.ST (pureST)
import Data.ArrayBuffer.Safe.TypedArray as TA
import Data.Either (Either(..))
import Data.Foldable (class Foldable, foldM)
import Data.Foldable as F
import Data.Function.Uncurried (Fn4, runFn4)
import Data.Maybe (Maybe(..))
import Data.NonEmpty (NonEmpty, (:|))
import Data.Tuple (Tuple(..))

mkAudioBuffer
  :: forall f
   . Foldable f
  => NonEmpty f TA.Float32Array
  -> Int
  -> Either String AudioBuffer
mkAudioBuffer channels@(c :| cs) samplerate =
  let options = {
        sampleRate: samplerate
      , numberOfChannels: Just $ F.length channels
      , length: TA.length c
      }
  in do
      unless (F.all (\channel -> TA.length channel == options.length) cs)
        $ Left "Channels of unequal length."
      pureST (
        mkSTAudioBuffer options >>= case _ of
          Left err -> pure <<< Left $ show err
          Right audioBuffer ->
            foldM (\(Tuple i eitherLastErr) channel ->
              case eitherLastErr of
                Left err -> pure $ (Tuple (i + 1) (Left err))
                Right unit -> Tuple (i + 1) <$>
                  copyToChannel audioBuffer channel i
            ) (Tuple 0 $ Right unit) channels >>= case _ of
              Tuple _ (Left err)   -> pure <<< Left $ show err
              Tuple _ (Right unit) -> Right <$> unsafeFreeze audioBuffer
      )
    
foreign import sampleRate :: AudioBuffer -> Number

foreign import length :: AudioBuffer -> Int

foreign import duration :: AudioBuffer -> Number

foreign import numberOfChannels :: AudioBuffer -> Int

getChannelData :: AudioBuffer -> Int -> Maybe TA.Float32Array
getChannelData = runFn4 getChannelDataImp Just Nothing

foreign import getChannelDataImp :: Fn4 (TA.Float32Array -> Maybe TA.Float32Array) (Maybe TA.Float32Array) AudioBuffer Int (Maybe TA.Float32Array)
