abstract class GptRepository {
  Future<String?> getSlimeResponse();
  Future<String?> getTodoEncouragement();
  Future<String?> getTaskFeedback();
  Future<String?> getGoalMotivation();
  Future<String?> getEmotionResponse(String emotion);
}
