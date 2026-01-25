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

/// 오디오 백엔드 초기화가 실패했을 때 앱이 크래시하지 않도록 사용하는 No-op 엔진.
///
/// - 모든 재생 요청을 무시하고, 안전한 기본값만 제공합니다.
class NoopAudioEngine implements AudioEngine {
  @override
  AudioSound play(AudioSource src, int a, int b, int c) => _NoopSound();

  @override
  int get sampleRate => 44100;

  @override
  int get channels => 2;

  @override
  int get timeInFrames => 0;

  @override
  void monitorLevels() {}

  @override
  double level(int ch) => 0;

  @override
  void dispose() {}
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
