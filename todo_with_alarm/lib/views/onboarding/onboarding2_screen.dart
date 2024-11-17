import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/onboarding/onboarding_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/text_fields/custom_text_field.dart';

class Onboarding2Page extends StatefulWidget {
  @override
  _Onboarding2PageState createState() => _Onboarding2PageState();
}

class _Onboarding2PageState extends State<Onboarding2Page> {
  final TextEditingController _nicknameController = TextEditingController();
  String? nicknameError;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OnboardingViewModel>(
      create: (_) => OnboardingViewModel(),
      child: Scaffold(
        backgroundColor: Color(0xFFFCFCFC),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(52),
          child: AppBar(
            backgroundColor: Color(0xFFFCFCFC),
            elevation: 0.5,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF1C1D1B)),
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
          ),
        ),
        body: Consumer<OnboardingViewModel>(
          builder: (context, viewModel, child) {
            return Stack(
              children: [
                // 노란색 곡면 배경
                Positioned(
                  left: -79.64,
                  // top 값을 줄여서 위로 올림
                  top: MediaQuery.of(context).size.height * 0.66,
                  child: Container(
                    width: 534.28,
                    height: 483.32,
                    decoration: ShapeDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.38, -0.93),
                        end: Alignment(-0.38, 0.93),
                        colors: [Color(0xFFFDFDFD), Color(0xFFFCF1BD)],
                      ),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
                // 캐릭터 및 그림자
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.5 - 93.14,
                  // top 값을 줄여서 위로 올림
                  top: MediaQuery.of(context).size.height * 0.50,
                  child: Column(
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
                    ],
                  ),
                ),
                // 배경과 캐릭터 뒤로 컨텐츠를 배치하기 위해 순서 변경
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

  void _validateNickname(OnboardingViewModel viewModel) {
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
      viewModel.saveNickname();
      // 다음 화면으로 이동하는 로직 추가
    }
  }
}