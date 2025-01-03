// Mocks generated by Mockito 5.4.4 from annotations
// in todo_with_alarm/test/mocks/mock_goal_service.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;

import 'package:hive/hive.dart' as _i3;
import 'package:http/http.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i6;
import 'package:todo_with_alarm/models/goal.dart' as _i4;
import 'package:todo_with_alarm/services/goal_service.dart' as _i5;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeClient_0 extends _i1.SmartFake implements _i2.Client {
  _FakeClient_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBox_1<E> extends _i1.SmartFake implements _i3.Box<E> {
  _FakeBox_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGoal_2 extends _i1.SmartFake implements _i4.Goal {
  _FakeGoal_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GoalService].
///
/// See the documentation for Mockito's code generation for more information.
class MockGoalService extends _i1.Mock implements _i5.GoalService {
  MockGoalService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get baseUrl => (super.noSuchMethod(
        Invocation.getter(#baseUrl),
        returnValue: _i6.dummyValue<String>(
          this,
          Invocation.getter(#baseUrl),
        ),
      ) as String);

  @override
  _i2.Client get httpClient => (super.noSuchMethod(
        Invocation.getter(#httpClient),
        returnValue: _FakeClient_0(
          this,
          Invocation.getter(#httpClient),
        ),
      ) as _i2.Client);

  @override
  _i3.Box<_i4.Goal> get goalBox => (super.noSuchMethod(
        Invocation.getter(#goalBox),
        returnValue: _FakeBox_1<_i4.Goal>(
          this,
          Invocation.getter(#goalBox),
        ),
      ) as _i3.Box<_i4.Goal>);

  @override
  _i7.Future<List<_i4.Goal>> loadGoals() => (super.noSuchMethod(
        Invocation.method(
          #loadGoals,
          [],
        ),
        returnValue: _i7.Future<List<_i4.Goal>>.value(<_i4.Goal>[]),
      ) as _i7.Future<List<_i4.Goal>>);

  @override
  List<_i4.Goal> getLocalGoals() => (super.noSuchMethod(
        Invocation.method(
          #getLocalGoals,
          [],
        ),
        returnValue: <_i4.Goal>[],
      ) as List<_i4.Goal>);

  @override
  _i7.Future<void> saveLocalGoals(List<_i4.Goal>? goals) => (super.noSuchMethod(
        Invocation.method(
          #saveLocalGoals,
          [goals],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> saveGoals(List<_i4.Goal>? goals) => (super.noSuchMethod(
        Invocation.method(
          #saveGoals,
          [goals],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<_i4.Goal> createGoal(_i4.Goal? goal) => (super.noSuchMethod(
        Invocation.method(
          #createGoal,
          [goal],
        ),
        returnValue: _i7.Future<_i4.Goal>.value(_FakeGoal_2(
          this,
          Invocation.method(
            #createGoal,
            [goal],
          ),
        )),
      ) as _i7.Future<_i4.Goal>);

  @override
  _i7.Future<void> updateGoal(_i4.Goal? goal) => (super.noSuchMethod(
        Invocation.method(
          #updateGoal,
          [goal],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> deleteGoal(String? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteGoal,
          [id],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> toggleGoalCompletion(String? id) => (super.noSuchMethod(
        Invocation.method(
          #toggleGoalCompletion,
          [id],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> giveUpGoal(String? goalId) => (super.noSuchMethod(
        Invocation.method(
          #giveUpGoal,
          [goalId],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
}
