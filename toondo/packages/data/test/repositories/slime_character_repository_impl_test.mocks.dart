// Mocks generated by Mockito 5.4.5 from annotations
// in data/test/repositories/slime_character_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;
import 'dart:io' as _i9;

import 'package:data/datasources/local/animation_local_datasource.dart' as _i8;
import 'package:data/datasources/remote/gpt_remote_datasource.dart' as _i5;
import 'package:domain/entities/gesture.dart' as _i10;
import 'package:domain/repositories/character_repository.dart' as _i4;
import 'package:domain/repositories/user_repository.dart' as _i3;
import 'package:http/http.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i7;

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

class _FakeClient_0 extends _i1.SmartFake implements _i2.Client {
  _FakeClient_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserRepository_1 extends _i1.SmartFake
    implements _i3.UserRepository {
  _FakeUserRepository_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCharacterRepository_2 extends _i1.SmartFake
    implements _i4.CharacterRepository {
  _FakeCharacterRepository_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GptRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockGptRemoteDataSource extends _i1.Mock
    implements _i5.GptRemoteDataSource {
  MockGptRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Client get httpClient => (super.noSuchMethod(
        Invocation.getter(#httpClient),
        returnValue: _FakeClient_0(
          this,
          Invocation.getter(#httpClient),
        ),
      ) as _i2.Client);

  @override
  _i3.UserRepository get userRepo => (super.noSuchMethod(
        Invocation.getter(#userRepo),
        returnValue: _FakeUserRepository_1(
          this,
          Invocation.getter(#userRepo),
        ),
      ) as _i3.UserRepository);

  @override
  _i4.CharacterRepository get characterRepo => (super.noSuchMethod(
        Invocation.getter(#characterRepo),
        returnValue: _FakeCharacterRepository_2(
          this,
          Invocation.getter(#characterRepo),
        ),
      ) as _i4.CharacterRepository);

  @override
  _i6.Future<String> chat(String? prompt) => (super.noSuchMethod(
        Invocation.method(
          #chat,
          [prompt],
        ),
        returnValue: _i6.Future<String>.value(_i7.dummyValue<String>(
          this,
          Invocation.method(
            #chat,
            [prompt],
          ),
        )),
      ) as _i6.Future<String>);
}

/// A class which mocks [AnimationLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockAnimationLocalDataSource extends _i1.Mock
    implements _i8.AnimationLocalDataSource {
  MockAnimationLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<void> load(_i9.File? riveAsset) => (super.noSuchMethod(
        Invocation.method(
          #load,
          [riveAsset],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<String> playByGesture(_i10.Gesture? g) => (super.noSuchMethod(
        Invocation.method(
          #playByGesture,
          [g],
        ),
        returnValue: _i6.Future<String>.value(_i7.dummyValue<String>(
          this,
          Invocation.method(
            #playByGesture,
            [g],
          ),
        )),
      ) as _i6.Future<String>);

  @override
  _i6.Future<String> playBySentiment(String? text) => (super.noSuchMethod(
        Invocation.method(
          #playBySentiment,
          [text],
        ),
        returnValue: _i6.Future<String>.value(_i7.dummyValue<String>(
          this,
          Invocation.method(
            #playBySentiment,
            [text],
          ),
        )),
      ) as _i6.Future<String>);
}
