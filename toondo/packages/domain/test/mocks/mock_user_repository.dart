import 'package:domain/entities/user.dart';
import 'package:domain/repositories/user_repository.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {
  @override
  Future<User> getUser() {
    return super.noSuchMethod(
      Invocation.method(#getUser, []),
      returnValue: Future.value(User(id: 1, loginId: 'test')),
      returnValueForMissingStub: Future.value(User(id: 1, loginId: 'test')),
    );
  }

  @override
  Future<User> updateNickName(String newNickName) {
    return super.noSuchMethod(
      Invocation.method(#updateNickName, [newNickName]),
      returnValue: Future.value(User(id: 1, loginId: 'test')),
      returnValueForMissingStub: Future.value(User(id: 1, loginId: 'test')),
    );
  }

  @override
  Future<String?> getUserNickname() {
    return super.noSuchMethod(
      Invocation.method(#getUserNickname, []),
      returnValue: Future.value(null),
      returnValueForMissingStub: Future.value(null),
    );
  }

  @override
  Future<void> deleteAccount() {
    return super.noSuchMethod(
      Invocation.method(#deleteAccount, []),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }
}
