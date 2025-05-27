import 'package:data/constants.dart';
import 'package:flutter_gemma/core/model.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma/pigeon.g.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/repositories/chat_llm.dart';
import 'package:flutter_gemma/core/chat.dart';

// DEBUG helper: simple alias for quickly disabling all prints
void _dbg(Object? msg) => print('[GemmaLocal] $msg');

/// 로컬 LiteRT-Gemma 모델로 바로 대화
@lazySingleton
class GemmaLocalDataSource implements ChatLLM {
  // ❶ .task 위치 (pubspec.yaml assets 목록에도 반드시 등록)
  static const _assetPath = 'llm/gemma3-1b-it-int4.task';

  final _plugin = FlutterGemmaPlugin.instance;
  InferenceModel? _model;               // lazy-load
  InferenceChat? _chat;                // persistent multi‑turn chat session
  bool _systemInjected = false;

  /// 내부에서 모델 설치 → 초기화까지 자동 처리
  Future<String> chat(String userPrompt) async {
    _dbg('chat() called. prompt length = ${userPrompt.length}');
    await _ensureModelReady();
    _dbg('model ready ✔');

    // ① 재사용 가능한 Chat 세션 확보 (한 번만 생성)
    _chat ??= InferenceChat(
      sessionCreator: () async => await _model!.createSession(
        temperature: 0.7,
        topK: 1,
      ),
      maxTokens: 4096,          // Gemma‑3 1B‑IT context window
      tokenBuffer: 512,         // 여유 버퍼
    );
    if (_chat!.fullHistory.isEmpty) {
      await _chat!.initSession();
    }

    // ② 이번 턴의 프롬프트 구성
    final sb = StringBuffer();
    if (!_systemInjected) {
      sb.writeln('<start_of_turn>system');
      sb.writeln(Constants.SLIMEROLE);
      sb.writeln('<end_of_turn>');
      _systemInjected = true;
    }
    sb
      ..writeln('<start_of_turn>user')
      ..writeln(userPrompt)
      ..writeln('<end_of_turn>')
      ..writeln('<start_of_turn>assistant');

    await _chat!.addQueryChunk(Message(text: sb.toString()));
    _dbg('prompt chunk added');

    // ③ 응답 받아오기
    final response = await _chat!.generateChatResponse();
    _dbg('response received (${response.length} chars)');
    _dbg('response: $response');
    return response;
  }

  /* ---------- private helpers ---------- */

  Future<void> _ensureModelReady() async {
    _dbg('_ensureModelReady()');
    // 이미 초기화돼 있으면 바로 반환
    if (_model != null) return;

    // 1) 모델 파일이 기기에 없는 경우 한 번만 설치
    final mgr = _plugin.modelManager;
    _dbg('checking model installation...');
    if (!await mgr.isModelInstalled) {
      _dbg('installing asset $_assetPath');
      await mgr.installModelFromAsset(_assetPath);
      _dbg('asset installed');
    }

    // 2) InferenceModel 생성 (init 대신 createModel 사용)
    _model = await _plugin.createModel(
      modelType: ModelType.gemmaIt,   // Gemma‑3 1B‑IT
      preferredBackend: PreferredBackend.cpu, // CPU 우선
      maxTokens: 1024,
    );
    _dbg('InferenceModel created (maxTokens 1024)');
  }
}