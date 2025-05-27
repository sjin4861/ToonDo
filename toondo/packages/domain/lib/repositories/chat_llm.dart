/// lib/domain/repositories/chat_llm.dart  (or /domain/services)
abstract interface class ChatLLM {
  /// 프롬프트를 넘기면 채팅 답변을 반환
  Future<String> chat(String prompt);
}