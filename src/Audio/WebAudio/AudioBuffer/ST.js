"use strict";

exports.copyToChannelImpl = function (
  just, nothing, stAudioBuffer, source, channelNumber) {
  try {
    stAudioBuffer.copyToChannel(source, channelNumber);
  }
  catch (e) {
    if (e instanceof INDEX_SIZE_ERR) return just(e);
    else throw e;
  }
  return nothing;
};

exports.copyToChannelWithOffsetImpl = function (
  just, nothing, stAudioBuffer, source, channelNumber, startInChannel) {
  try {
    stAudioBuffer.copyToChannel(source, channelNumber, startInChannel);
  }
  catch (e) {
    if (e instanceof INDEX_SIZE_ERR) return just(e);
    else throw e;
  }
  return nothing;
};
