// Mocks generated by Mockito 5.4.5 from annotations
// in presentation/test/viewmodels/signup/signup_viewmodel_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:domain/entities/user.dart' as _i3;
import 'package:domain/repositories/auth_repository.dart' as _i2;
import 'package:domain/repositories/sms_repository.dart' as _i4;
import 'package:domain/usecases/auth/check_phone_number_exists.dart' as _i10;
import 'package:domain/usecases/auth/register.dart' as _i5;
import 'package:domain/usecases/sms/send_sms_code.dart' as _i7;
import 'package:domain/usecases/sms/verify_sms_code.dart' as _i9;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i8;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeAuthRepository_0 extends _i1.SmartFake
    implements _i2.AuthRepository {
  _FakeAuthRepository_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeUser_1 extends _i1.SmartFake implements _i3.User {
  _FakeUser_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeSmsRepository_2 extends _i1.SmartFake implements _i4.SmsRepository {
  _FakeSmsRepository_2(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [RegisterUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockRegisterUseCase extends _i1.Mock implements _i5.RegisterUseCase {
  MockRegisterUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AuthRepository get repository =>
      (super.noSuchMethod(
            Invocation.getter(#repository),
            returnValue: _FakeAuthRepository_0(
              this,
              Invocation.getter(#repository),
            ),
          )
          as _i2.AuthRepository);

  @override
  _i6.Future<_i3.User> call(String? phoneNumber, String? password) =>
      (super.noSuchMethod(
            Invocation.method(#call, [phoneNumber, password]),
            returnValue: _i6.Future<_i3.User>.value(
              _FakeUser_1(
                this,
                Invocation.method(#call, [phoneNumber, password]),
              ),
            ),
          )
          as _i6.Future<_i3.User>);
}

/// A class which mocks [SendSmsCode].
///
/// See the documentation for Mockito's code generation for more information.
class MockSendSmsCode extends _i1.Mock implements _i7.SendSmsCode {
  MockSendSmsCode() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.SmsRepository get repository =>
      (super.noSuchMethod(
            Invocation.getter(#repository),
            returnValue: _FakeSmsRepository_2(
              this,
              Invocation.getter(#repository),
            ),
          )
          as _i4.SmsRepository);

  @override
  _i6.Future<String> call(String? phoneNumber) =>
      (super.noSuchMethod(
            Invocation.method(#call, [phoneNumber]),
            returnValue: _i6.Future<String>.value(
              _i8.dummyValue<String>(
                this,
                Invocation.method(#call, [phoneNumber]),
              ),
            ),
          )
          as _i6.Future<String>);
}

/// A class which mocks [VerifySmsCode].
///
/// See the documentation for Mockito's code generation for more information.
class MockVerifySmsCode extends _i1.Mock implements _i9.VerifySmsCode {
  MockVerifySmsCode() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.SmsRepository get repository =>
      (super.noSuchMethod(
            Invocation.getter(#repository),
            returnValue: _FakeSmsRepository_2(
              this,
              Invocation.getter(#repository),
            ),
          )
          as _i4.SmsRepository);

  @override
  _i6.Future<String> call(String? phoneNumber, String? code) =>
      (super.noSuchMethod(
            Invocation.method(#call, [phoneNumber, code]),
            returnValue: _i6.Future<String>.value(
              _i8.dummyValue<String>(
                this,
                Invocation.method(#call, [phoneNumber, code]),
              ),
            ),
          )
          as _i6.Future<String>);
}

/// A class which mocks [CheckPhoneNumberExistsUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockCheckPhoneNumberExistsUseCase extends _i1.Mock
    implements _i10.CheckPhoneNumberExistsUseCase {
  MockCheckPhoneNumberExistsUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AuthRepository get repository =>
      (super.noSuchMethod(
            Invocation.getter(#repository),
            returnValue: _FakeAuthRepository_0(
              this,
              Invocation.getter(#repository),
            ),
          )
          as _i2.AuthRepository);

  @override
  _i6.Future<bool> call(String? phoneNumber) =>
      (super.noSuchMethod(
            Invocation.method(#call, [phoneNumber]),
            returnValue: _i6.Future<bool>.value(false),
          )
          as _i6.Future<bool>);
}
