import 'package:flutter/foundation.dart';
import 'package:domain/usecases/character/slime_on_massage.dart';
import 'package:domain/entities/slime_response.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/entities/todo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChatViewModel extends ChangeNotifier {
  final SlimeOnMessageUseCase _onMessage;
  ChatViewModel(this._onMessage);

  /// 채팅 내역
  final List<SlimeResponse> _messages = [];
  List<SlimeResponse> get messages => List.unmodifiable(_messages);

  /// 전송 중(로딩) 상태
  bool _isSending = false;
  bool get isSending => _isSending;

  Future<void> send({
    required String text,
    List<Goal> goals = const [],
    List<Todo> todos = const [],
  }) async {
    if (text.trim().isEmpty) return;
    _isSending = true;
    notifyListeners();

    // 사용자 말 먼저 추가
    _messages.add(SlimeResponse(message: text, animationKey: 'id'));
    _messages.add(const SlimeResponse(message: '…', animationKey: 'id'));
    notifyListeners();

    final reply =
        await _onMessage(text: text, goals: goals, todos: todos);
    _messages.removeLast();   
    _messages.add(reply);
    _isSending = false;
    notifyListeners();
  }
}
