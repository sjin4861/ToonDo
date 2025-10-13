import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:rive_common/rive_audio.dart';

class AudioGate implements AudioEngine {
  AudioGate({
    required this.inner,
    required this.enabled,
  });

  final AudioEngine inner;
  final ValueListenable<bool> enabled;

  @override
  AudioSound play(AudioSource src, int a, int b, int c) {
    print('[AudioGate] enabled=${enabled.value}');
    if (!enabled.value) return _NoopSound();
    return inner.play(src, a, b, c);
  }

  static StreamingAudioSource loadSource(Uint8List bytes) =>
      AudioEngine.loadSource(bytes);

  // 나머지 위임
  @override
  int get sampleRate => inner.sampleRate;
  @override
  int get channels => inner.channels;
  @override
  int get timeInFrames => inner.timeInFrames;
  @override
  void monitorLevels() => inner.monitorLevels();
  @override
  double level(int ch) => inner.level(ch);
  @override
  void dispose() => inner.dispose();
}

// No-op 사운드 객체
class _NoopSound implements AudioSound {
  double _v = 0;
  @override
  void stop({Duration fadeTime = Duration.zero}) {}
  @override
  double get volume => _v;
  @override
  set volume(double v) => _v = v;
  @override
  void dispose() {}
  @override
  bool get completed => true;
}
