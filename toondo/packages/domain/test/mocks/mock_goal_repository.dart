import 'package:domain/entities/goal.dart';
import 'package:domain/entities/status.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:mockito/mockito.dart';

class MockGoalRepository extends Mock implements GoalRepository {
  @override
  List<Goal> getGoalsLocal() {
    return super.noSuchMethod(
      Invocation.method(#getGoalsLocal, []),
      returnValue: <Goal>[],
      returnValueForMissingStub: <Goal>[],
    );
  }
  
  @override
  Future<Goal?> getGoalByIdLocal(String goalId) {
    return super.noSuchMethod(
      Invocation.method(#getGoalByIdLocal, [goalId]),
      returnValue: Future.value(null),
      returnValueForMissingStub: Future.value(null),
    );
  }
  
  @override
  Future<void> saveGoalLocal(Goal goal) {
    return super.noSuchMethod(
      Invocation.method(#saveGoalLocal, [goal]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }
  
  @override
  Future<void> updateGoalLocal(Goal goal) {
    return super.noSuchMethod(
      Invocation.method(#updateGoalLocal, [goal]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }
  
  @override
  Future<void> deleteGoalLocal(String goalId) {
    return super.noSuchMethod(
      Invocation.method(#deleteGoalLocal, [goalId]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }
  
  @override
  Future<List<Goal>> fetchGoalsRemote() {
    return super.noSuchMethod(
      Invocation.method(#fetchGoalsRemote, []),
      returnValue: Future.value(<Goal>[]),
      returnValueForMissingStub: Future.value(<Goal>[]),
    );
  }
  
  @override
  Future<Goal> createGoalRemote(Goal goal) {
    return super.noSuchMethod(
      Invocation.method(#createGoalRemote, [goal]),
      returnValue: Future.value(goal),
      returnValueForMissingStub: Future.value(goal),
    );
  }
  
  @override
  Future<bool> updateGoalStatusRemote(Goal goal, Status newStatus) {
    return super.noSuchMethod(
      Invocation.method(#updateGoalStatusRemote, [goal, newStatus]),
      returnValue: Future.value(true),
      returnValueForMissingStub: Future.value(true),
    );
  }
  
  @override
  Future<bool> updateGoalProgressRemote(Goal goal, double newProgress) {
    return super.noSuchMethod(
      Invocation.method(#updateGoalProgressRemote, [goal, newProgress]),
      returnValue: Future.value(true),
      returnValueForMissingStub: Future.value(true),
    );
  }
  
  @override
  Future<void> updateGoalRemote(Goal goal) {
    return super.noSuchMethod(
      Invocation.method(#updateGoalRemote, [goal]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }
  
  @override
  Future<void> deleteGoalRemote(String goalId) {
    return super.noSuchMethod(
      Invocation.method(#deleteGoalRemote, [goalId]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }
}