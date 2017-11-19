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
import Data.Either (Either(..))
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
   -> Eff (st :: ST h | r) (Either Error Unit)
copyToChannel = runEffFn5 copyToChannelImpl Left (Right unit)

copyToChannelWithOffset
  :: forall h r
   .  (STAudioBuffer h)
   -> Float32Array
   -> Int
   -> Int
   -> Eff (st :: ST h | r) (Either Error Unit)
copyToChannelWithOffset = runEffFn6 copyToChannelWithOffsetImpl Left (Right unit)

foreign import copyToChannelImpl
  :: forall h r
   . EffFn5 (st :: ST h | r)
            (Error -> Either Error Unit)
            (Either Error Unit)
            (STAudioBuffer h)
            Float32Array
            Int
            (Either Error Unit)

foreign import copyToChannelWithOffsetImpl
  :: forall h r
   . EffFn6 (st :: ST h | r)
            (Error -> Either Error Unit)
            (Either Error Unit)
            (STAudioBuffer h)
            Float32Array
            Int
            Int
            (Either Error Unit)
