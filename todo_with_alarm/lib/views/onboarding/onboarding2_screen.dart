import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/views/home/home_screen.dart';
import '../../viewmodels/onboarding/onboarding_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/text_fields/custom_text_field.dart';
import '../home/home_screen.dart'; // 홈 화면 임포트

class Onboarding2Page extends StatefulWidget {
  final String userId;
  
  Onboarding2Page({required this.userId});

  @override
  _Onboarding2PageState createState() => _Onboarding2PageState();
}

class _Onboarding2PageState extends State<Onboarding2Page> {
  final TextEditingController _nicknameController = TextEditingController();
  String? nicknameError;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OnboardingViewModel>(
      create: (_) => OnboardingViewModel(userId: widget.userId),
      child: Scaffold(
        // ... 기존 코드 생략 ...
        body: Consumer<OnboardingViewModel>(
          builder: (context, viewModel, child) {
            return Stack(
              children: [
                // ... 기존 코드 생략 ...
                // 컨텐츠
                Positioned.fill(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(24, 32, 24, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 상단 안내 문구
                                SizedBox(height: 84),
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
                                SizedBox(height: 32),
                                // 닉네임 입력란
                                CustomTextField(
                                  label: '닉네임',
                                  hintText: '8자 이내의 닉네임을 입력해주세요',
                                  controller: _nicknameController,
                                  onChanged: (value) {
                                    setState(() {
                                      viewModel.nickname = value;
                                      nicknameError = null;
                                    });
                                  },
                                  errorText: nicknameError,
                                  isValid: viewModel.nickname.isNotEmpty,
                                  borderColor: viewModel.nickname.isNotEmpty
                                      ? Color(0xFF78B545)
                                      : Color(0xFFDDDDDD),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                ),
                                if (nicknameError != null) ...[
                                  SizedBox(height: 4),
                                  Text(
                                    nicknameError!,
                                    style: TextStyle(
                                      color: Color(0xFFEE0F12),
                                      fontSize: 10,
                                      fontFamily: 'Pretendard Variable',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.15,
                                    ),
                                  ),
                                ],
                                SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // 버튼들
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 0, 24, 32),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: () {
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
                                onPressed: () {
                                  _validateNickname(viewModel);
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
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _validateNickname(OnboardingViewModel viewModel) async {
    if (viewModel.nickname.isEmpty) {
      setState(() {
        nicknameError = '닉네임을 입력해주세요.';
      });
    } else if (viewModel.nickname.length > 8) {
      setState(() {
        nicknameError = '닉네임은 8자 이내로 입력해주세요.';
      });
    } else {
      // 닉네임 저장 및 다음 화면으로 이동
      try {
        viewModel.saveNickname();
        // 홈 화면으로 이동
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      } catch (e) {
        // 에러 처리 (예: 현재 로그인된 사용자가 없음)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}