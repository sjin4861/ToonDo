import 'package:data/datasources/local/goal_local_datasource.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/entities/status.dart';
import 'package:mockito/mockito.dart';

class MockGoalLocalDatasource extends Mock implements GoalLocalDatasource {
  @override
  Future<void> clearGoals() {
    return super.noSuchMethod(
      Invocation.method(#clearGoals, []),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }
  
  @override
  Future<void> saveGoal(Goal goal) {
    return super.noSuchMethod(
      Invocation.method(#saveGoal, [goal]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }
  
  @override
  List<Goal> getAllGoals() {
    return super.noSuchMethod(
      Invocation.method(#getAllGoals, []),
      returnValue: <Goal>[],
      returnValueForMissingStub: <Goal>[],
    );
  }
  
  @override
  Future<void> updateGoal(Goal goal) {
    return super.noSuchMethod(
      Invocation.method(#updateGoal, [goal]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }
  
  @override
  Future<void> deleteGoal(String goalId) {
    return super.noSuchMethod(
      Invocation.method(#deleteGoal, [goalId]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }
  
  @override
  Future<void> updateGoalStatus(Goal goal, Status newStatus) {
    return super.noSuchMethod(
      Invocation.method(#updateGoalStatus, [goal, newStatus]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }
  
  @override
  Future<void> updateGoalProgress(Goal goal, double newProgress) {
    return super.noSuchMethod(
      Invocation.method(#updateGoalProgress, [goal, newProgress]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }
}