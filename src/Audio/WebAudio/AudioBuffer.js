"use strict";

exports.sampleRate = function(audioBuffer) {
  return audioBuffer.sampleRate;
};

exports.length = function(audioBuffer) {
  return audioBuffer.length;
};

exports.duration = function(audioBuffer) {
  return audioBuffer.duration;
};

exports.numberOfChannels = function(audioBuffer) {
  return audioBuffer.numberOfChannels;
};

exports.getChannelDataImp = function(just, nothing, audioBuffer, channel) {
  try {
    return just(audioBuffer.getChannelData(channel));
  }
  catch (e) {
    if (e instanceof INDEX_SIZE_ERR) return nothing;
    else throw e;
  }
};
