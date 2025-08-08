import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:domain/usecases/auth/get_token.dart';
import 'package:domain/usecases/auth/logout.dart';
import 'package:presentation/viewmodels/welcome/welcome_viewmodel.dart';
import 'package:presentation/navigation/route_paths.dart';
import 'welcome_viewmodel_test.mocks.dart';

// generate mock classes with Mockito 5.0+
@GenerateMocks([GetTokenUseCase, LogoutUseCase, BuildContext, NavigatorState])
void main() {
  late WelcomeViewModel viewModel;
  late MockGetTokenUseCase mockGetTokenUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockBuildContext mockContext;
  late MockNavigatorState mockNavigator;

  setUp(() {
    mockGetTokenUseCase = MockGetTokenUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockContext = MockBuildContext();
    mockNavigator = MockNavigatorState();
    
    // NavigatorState를 반환하도록 설정
    when(mockContext.findAncestorStateOfType<NavigatorState>()).thenReturn(mockNavigator);
    // Navigator 동작 stub
    when(mockNavigator.pushReplacementNamed(any)).thenAnswer((_) async => null);
    when(mockNavigator.push(any)).thenAnswer((_) async => null);
    when(mockNavigator.pushReplacement(any)).thenAnswer((_) async => null);

    viewModel = WelcomeViewModel(
      getTokenUseCase: mockGetTokenUseCase,
      logoutUseCase: mockLogoutUseCase,
    );
  });

  group('WelcomeViewModel', () {
    group('로그인 상태 확인', () {
      test('토큰이 없으면 로그인 화면에 머물러야 한다', () async {
        // Given
        when(mockGetTokenUseCase.call()).thenAnswer((_) async => null);
        
        // When
        await viewModel.init(mockContext);
        
        // Then
        verify(mockGetTokenUseCase.call()).called(1);
        verifyNever(mockLogoutUseCase.call());
        verifyNever(mockNavigator.pushReplacementNamed(any));
      });

      test('유효한 토큰이 있으면 홈 화면으로 이동해야 한다', () async {
        // Given - 만료되지 않은 JWT 토큰 형식 (만료일을 미래로 설정)
        final int futureExpiry = DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch ~/ 1000;
        final String validTokenPayload = '{"exp": $futureExpiry}'; // 유효한 만료 시간
        final String encodedPayload = base64Url.encode(utf8.encode(validTokenPayload));
        final String validToken = 'header.$encodedPayload.signature';
        
        when(mockGetTokenUseCase.call()).thenAnswer((_) async => validToken);

        // When
        await viewModel.init(mockContext);
        
        // Then
        verify(mockGetTokenUseCase.call()).called(1);
        verifyNever(mockLogoutUseCase.call());
        verify(mockNavigator.pushReplacementNamed(RoutePaths.home)).called(1);
      });

      test('만료된 토큰이 있으면 로그아웃 처리 후 로그인 화면에 머물러야 한다', () async {
        // Given - 만료된 JWT 토큰 형식 (만료일을 과거로 설정)
        final int pastExpiry = DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch ~/ 1000;
        final String expiredTokenPayload = '{"exp": $pastExpiry}';
        final String encodedPayload = base64Url.encode(utf8.encode(expiredTokenPayload));
        final String expiredToken = 'header.$encodedPayload.signature';
        
        when(mockGetTokenUseCase.call()).thenAnswer((_) async => expiredToken);
        when(mockLogoutUseCase.call()).thenAnswer((_) async {});

        // When
        await viewModel.init(mockContext);
        
        // Then
        verify(mockGetTokenUseCase.call()).called(1);
        verify(mockLogoutUseCase.call()).called(1);
        verifyNever(mockNavigator.pushReplacementNamed(any));
      });
    });

    // 로그인 방법 테스트는 실제 내부 구현이 없기 때문에 간단히 작성
    group('로그인 방법', () {
      test('continueWithGoogle 호출 시 에러가 발생하지 않아야 한다', () {
        // When/Then
        expect(() => viewModel.continueWithGoogle(mockContext), returnsNormally);
      });

      test('continueWithKakao 호출 시 에러가 발생하지 않아야 한다', () {
        // When/Then
        expect(() => viewModel.continueWithKakao(mockContext), returnsNormally);
      });

      test('continueWithPhoneNumber 호출 시 회원가입 화면으로 이동해야 한다', () {
        // When
        viewModel.continueWithPhoneNumber(mockContext);
        
        // Then
        // 회원가입 화면 이동 검증 (Navigator.push 호출 검증)
        verify(mockNavigator.push(any)).called(1);
      });

      test('continueWithoutLogin 호출 시 온보딩 화면으로 이동해야 한다', () {
        // When
        viewModel.continueWithoutLogin(mockContext);
        
        // Then
        // 온보딩 화면 이동 검증 (Navigator.pushReplacement 호출 검증)
        verify(mockNavigator.pushReplacement(any)).called(1);
      });
    });
  });
}