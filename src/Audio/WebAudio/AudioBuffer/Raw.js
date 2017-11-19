"use strict"; 

exports.mkAudioBufferImpl = function (left, right, options) {
  try {
    return right(new AudioBuffer(options));
  }
  catch (e) {
    return left(e);
  }
};
