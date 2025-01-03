// integration_test/auth_flow_test.dart

@Tags(['patrol'])
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todo_with_alarm/main.dart';

void main() {
  // 만약 flutter test 로도 실행하려면 아래 주석 해제:
  // PatrolBinding.ensureInitialized();
  patrolTest(
    '앱 초기 실행 시 알림 권한 요청 흐름 테스트',
    ($) async {
      // 앱 위젯 로드
      await $.pumpWidgetAndSettle(const MyApp());

      // 알림 권한 요청 다이얼로그가 나타날 때까지 대기
      await $.native.waitUntilVisible(
        Selector(text: '앱이 알림을 보내려고 합니다. 허용하시겠습니까?'),
        timeout: const Duration(seconds: 5),
      );

      // '허용' 버튼을 찾아 탭
      await $.native.tap(Selector(text: '허용'));

      // 권한이 부여되었는지 확인
      // (여기서는 알림 권한이 부여된 후 나타나는 특정 위젯을 확인)
      expect(find.text('알림 권한이 허용되었습니다.'), findsOneWidget);
    },
  );
  patrolTest(
    '회원가입 후 로그인까지 정상 동작하는지 테스트',
    ($) async {
      // 2) 앱 구동
      await $.pumpWidgetAndSettle(MyApp());
      // ↑ MyApp()이 MaterialApp과 Navigator를 잘 감싸고 있다고 가정

      // 3) 회원가입 Step1: [휴대폰 번호로 계속하기] 버튼 탭
      await $('continueWithPhoneNumberButton').tap();
      await $.pumpAndSettle();

      // 4) Step1: 휴대폰 번호 입력
      await $('signupStep1_phoneNumberField').enterText('01012345678');
      await $.pumpAndSettle();

      // 5) Step1 → [다음으로] 버튼
      await $('signupStep1_nextButton').tap();
      await $.pumpAndSettle();

      // 6) 회원가입 Step2: 비밀번호 입력
      await $('signupStep2_passwordField').enterText('password123');
      await $.pumpAndSettle();

      // 7) Step2 → [다음으로]
      await $('signupStep2_nextButton').tap();
      await $.pumpAndSettle();

      // 서버 회원가입 성공 시 OnboardingScreen → 3초 후 Onboarding2Page로 이동한다고 했으므로
      // 대략 5초 정도 대기
      await $.pumpAndSettle(timeout: const Duration(seconds: 5));

      // 8) Onboarding2Page: 닉네임 입력
      await $('onboarding2_nicknameTextField').enterText('마동석');
      await $.pumpAndSettle();

      // 9) Onboarding2Page → [다음으로] → HomeScreen 이동
      await $('onboarding2_nextButton').tap();
      await $.pumpAndSettle();

      // HomeScreen에 "ToonDo" 텍스트가 있다고 가정
      expect(find.text('ToonDo'), findsOneWidget);

      // 10) (옵션) 로그인 테스트 이어서 수행
      await $('goToLoginButton').tap();
      await $.pumpAndSettle();

      // 11) 로그인 화면: 비밀번호 입력
      await $('login_passwordField').enterText('password123');
      await $.pumpAndSettle();

      // 12) [다음으로] 버튼 탭
      await $('login_nextButton').tap();
      await $.pumpAndSettle();

      // 13) 로그인 후 홈화면(“ToonDo”)이 보이는지 확인
      expect(find.text('ToonDo'), findsOneWidget);
    },
  );
}

// 필요하다면 테스트 코드에서 사용하기 위한 임시 클래스
class $ {
  // 이 클래스를 왜 쓰는지에 따라 내용 추가 가능
}