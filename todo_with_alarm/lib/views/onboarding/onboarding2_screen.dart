// lib/views/onboarding/onboarding2_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/onboarding/onboarding_viewmodel.dart';
import '../../widgets/text_fields/custom_text_field.dart';
import '../home/home_screen.dart';

class Onboarding2Page extends StatefulWidget {
  final int userId;

  Onboarding2Page({required this.userId});

  @override
  _Onboarding2PageState createState() => _Onboarding2PageState();
}

class _Onboarding2PageState extends State<Onboarding2Page> {
  final TextEditingController _nicknameController = TextEditingController();
  String? nicknameError;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OnboardingViewModel>(
      create: (_) => OnboardingViewModel(userId: widget.userId),
      child: Scaffold(
        backgroundColor: Color(0xFFFCFCFC),
        appBar: AppBar(
          backgroundColor: Color(0xFFFCFCFC),
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFF1C1D1B),
              size: 16,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '시작하기',
            style: TextStyle(
              color: Color(0xFF1C1D1B),
              fontSize: 16,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.24,
            ),
          ),
          centerTitle: false,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0.5),
            child: Container(
              color: Color(0x3F1C1D1B),
              height: 0.5,
            ),
          ),
        ),
        body: Stack(
            children: [
              // 배경 타원
              Positioned(
                left: -100,
                bottom: -280,
                child: Container(
                  width: 600,
                  height: 600,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(252, 241, 190, 1),
                        Color.fromRGBO(249, 228, 123, 1),
                      ],
                    ),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              // 메인 콘텐츠
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '당신의 이름도 저에게 알려 주실래요?',
                              style: TextStyle(
                                color: Color(0xFF78B545),
                                fontSize: 16,
                                fontFamily: 'Pretendard Variable',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.24,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '툰두에서 사용하고 싶은 닉네임을 적어주세요',
                              style: TextStyle(
                                color: Color(0xBF1C1D1B),
                                fontSize: 10,
                                fontFamily: 'Pretendard Variable',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.15,
                              ),
                            ),
                            SizedBox(height: 64),
                            Consumer<OnboardingViewModel>(
                              builder: (context, viewModel, child) {
                                return CustomTextField(
                                  key: const Key('onboarding2_nicknameTextField'), // ★ 추가
                                  label: '닉네임',
                                  hintText: '8자 이내의 닉네임을 입력해주세요',
                                  controller: _nicknameController,
                                  onChanged: (value) {
                                    setState(() {
                                      nicknameError = null;
                                    });
                                    viewModel.nickname = value;
                                  },
                                  errorText: nicknameError,
                                  isValid: viewModel.nickname.isNotEmpty,
                                  borderColor: viewModel.nickname.isNotEmpty
                                      ? Color(0xFF78B545)
                                      : Color(0xFFDDDDDD),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                );
                              },
                            ),
                            if (nicknameError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  nicknameError!,
                                  style: TextStyle(
                                    color: Color(0xFFEE0F12),
                                    fontSize: 10,
                                    fontFamily: 'Pretendard Variable',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.15,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 캐릭터 및 그림자
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/character.svg',
                        width: 186.29,
                        height: 134.30,
                      ),
                      SizedBox(height: 12.44),
                      SvgPicture.asset(
                        'assets/icons/shadow.svg',
                        width: 139.30,
                        height: 21.99,
                      ),
                      SizedBox(height: 180),
                      // 버튼 배치
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: () {
                                  // 이전 화면으로 이동
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFEEEEEE),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1000),
                                  ),
                                  padding: EdgeInsets.all(16),
                                ),
                                child: Text(
                                  '뒤로',
                                  style: TextStyle(
                                    color: Color(0x7F1C1D1B),
                                    fontSize: 14,
                                    fontFamily: 'Pretendard Variable',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.21,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                key: const Key('onboarding2_nextButton'), // ★ 추가
                                onPressed: () {
                                  _validateNickname(
                                      Provider.of<OnboardingViewModel>(context, listen: false));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF78B545),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1000),
                                  ),
                                  padding: EdgeInsets.all(16),
                                ),
                                child: Text(
                                  '다음으로',
                                  style: TextStyle(
                                    color: Color(0xFFFCFCFC),
                                    fontSize: 14,
                                    fontFamily: 'Pretendard Variable',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.21,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }

  void _validateNickname(OnboardingViewModel viewModel) async {
    final nickname = viewModel.nickname;
    if (nickname.isEmpty) {
      setState(() {
        nicknameError = '닉네임을 입력해주세요.';
      });
    } else if (nickname.length > 8) {
      setState(() {
        nicknameError = '닉네임은 8자 이내로 입력해주세요.';
      });
    } else {
      // 닉네임 저장 및 다음 화면으로 이동
      try {
        await viewModel.saveNickname(); // saveNickname 메서드가 비동기 함수라고 가정
        // 홈 화면으로 이동
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      } catch (e) {
        // 에러 처리 (예: 현재 로그인된 사용자가 없음)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('닉네임 저장 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }
}