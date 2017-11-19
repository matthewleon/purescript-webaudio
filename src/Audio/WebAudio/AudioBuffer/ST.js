"use strict";

exports.copyToChannelImpl = function (
  left, rightUnit, stAudioBuffer, source, channelNumber) {
  try {
    stAudioBuffer.copyToChannel(source, channelNumber);
  }
  catch (e) {
    if (e instanceof INDEX_SIZE_ERR) return left(e);
    else throw e;
  }
  return rightUnit;
};

exports.copyToChannelWithOffsetImpl = function (
  left, rightUnit, stAudioBuffer, source, channelNumber, startInChannel) {
  try {
    stAudioBuffer.copyToChannel(source, channelNumber, startInChannel);
  }
  catch (e) {
    if (e instanceof INDEX_SIZE_ERR) return left(e);
    else throw e;
  }
  return rightUnit;
};
