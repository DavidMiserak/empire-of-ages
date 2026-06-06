// Empire of Ages — SoundThrottle utility
// Decision D8: Prevent audio from playing the same SFX multiple times within
// a 80ms window. Without throttle, 10 units hitting at once = 10 identical
// impact sounds = ear-piercing noise. With throttle, the first hit plays,
// subsequent hits within 80ms are dropped (silently), next hit after 80ms
// plays again.
//
// Usage:
//   final throttle = SoundThrottle();
//   if (throttle.allow('hit')) {
//     flameAudio.play('sfx/hash1.mp3');
//   }

class SoundThrottle {
  static const int _throttleMs = 80; // milliseconds
  final Map<String, DateTime> _lastPlayTime = {};

  /// Check if an SFX is allowed to play. If the same key was played within
  /// 80ms, return false (drop the sound). Otherwise return true (allow it to
  /// play) and record the current time.
  bool allow(String soundKey) {
    final now = DateTime.now();
    final last = _lastPlayTime[soundKey];
    if (last == null ||
        now.difference(last).inMilliseconds >= _throttleMs) {
      _lastPlayTime[soundKey] = now;
      return true;
    }
    return false;
  }

  /// Reset throttle state (called on game reset).
  void reset() {
    _lastPlayTime.clear();
  }
}
