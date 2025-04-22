import 'package:data/datasources/remote/goal_remote_datasource.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/entities/status.dart';
import 'package:mockito/mockito.dart';

class MockGoalRemoteDataSource extends Mock implements GoalRemoteDataSource {
  @override
  Future<List<Goal>> readGoals() {
    return super.noSuchMethod(
      Invocation.method(#readGoals, []),
      returnValue: Future.value(<Goal>[]),
      returnValueForMissingStub: Future.value(<Goal>[]),
    );
  }
  
  @override
  Future<Goal> createGoal(Goal goal) {
    return super.noSuchMethod(
      Invocation.method(#createGoal, [goal]),
      returnValue: Future.value(goal),
      returnValueForMissingStub: Future.value(goal),
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
  Future<bool> updateGoalStatus(Goal goal, Status newStatus) {
    return super.noSuchMethod(
      Invocation.method(#updateGoalStatus, [goal, newStatus]),
      returnValue: Future.value(true),
      returnValueForMissingStub: Future.value(true),
    );
  }
  
  @override
  Future<bool> updateGoalProgress(Goal goal, double newProgress) {
    return super.noSuchMethod(
      Invocation.method(#updateGoalProgress, [goal, newProgress]),
      returnValue: Future.value(true),
      returnValueForMissingStub: Future.value(true),
    );
  }
}