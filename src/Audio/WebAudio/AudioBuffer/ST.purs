module Audio.WebAudio.AudioBuffer.ST (
  STAudioBuffer
, mkSTAudioBuffer
, unsafeFreeze
, copyToChannel
, copyToChannelWithOffset
) where

import Prelude

import Audio.WebAudio.AudioBuffer.Raw as Raw
import Audio.WebAudio.Types (AudioBuffer)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)
import Control.Monad.Eff.Uncurried (EffFn5, EffFn6, runEffFn5, runEffFn6)
import Control.Monad.ST (ST)
import Data.ArrayBuffer.Types (Float32Array)
import Data.Either (Either)
import Data.Maybe (Maybe(..))
import Unsafe.Coerce (unsafeCoerce)

foreign import data STAudioBuffer :: Type -> Type

mkSTAudioBuffer
  :: forall h r
   . Raw.AudioBufferOptions
  -> Eff (st :: ST h | r) (Either Error (STAudioBuffer h))
mkSTAudioBuffer = pure <<< map unsafeCoerce <<< Raw.mkAudioBuffer

unsafeFreeze :: forall h r. STAudioBuffer h -> Eff (st :: ST h | r) AudioBuffer
unsafeFreeze = pure <<< unsafeCoerce

copyToChannel
  :: forall h r
   . (STAudioBuffer h)
   -> Float32Array
   -> Int
   -> Eff (st :: ST h | r) (Maybe Error)
copyToChannel = runEffFn5 copyToChannelImpl Just Nothing

copyToChannelWithOffset
  :: forall h r
   .  (STAudioBuffer h)
   -> Float32Array
   -> Int
   -> Int
   -> Eff (st :: ST h | r) (Maybe Error)
copyToChannelWithOffset = runEffFn6 copyToChannelWithOffsetImpl Just Nothing

foreign import copyToChannelImpl
  :: forall h r
   . EffFn5 (st :: ST h | r)
            (Error -> Maybe Error)
            (Maybe Error)
            (STAudioBuffer h)
            Float32Array
            Int
            (Maybe Error)

foreign import copyToChannelWithOffsetImpl
  :: forall h r
   . EffFn6 (st :: ST h | r)
            (Error -> Maybe Error)
            (Maybe Error)
            (STAudioBuffer h)
            Float32Array
            Int
            Int
            (Maybe Error)
