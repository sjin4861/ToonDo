import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:common/gen/assets.gen.dart';
import 'package:presentation/viewmodels/welcome/welcome_viewmodel.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/designsystem/components/buttons/app_phone_login_button.dart';
import 'package:presentation/views/mypage/help_guide/legal/legal_texts.dart';
import 'package:presentation/views/welcome/widget/legal_bottom_sheet.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: AppSpacing.v184),
          SizedBox(height: AppSpacing.v32), // 소셜 로그인 사용 시 해당 라인 삭제
          _buildCharacterSection(),
          SizedBox(height: AppSpacing.v28),
          _buildWelcomeText(),
          // SizedBox(height: AppSpacing.v52), // 소셜 로그인 사용 시 주석 해제
          _buildButtons(context),
          Spacer(),
          _buildTermsText(context),
        ],
      ),
    );
  }

  Widget _buildCharacterSection() {
    return Column(
      children: [
        Assets.images.imgWelcomeCharacter.image(
          width: 187.w,
          height: 140.h,
        ),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '오늘부터 툰두와 함께 갓생을 시작해볼까요?',
          style: AppTypography.caption1Regular.copyWith(
            color: AppColors.status100_75,
          ),
        ),
        SizedBox(height: AppSpacing.v8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '당신의 똑똑한 갓생 도우미, ',
                style: AppTypography.h2Bold.copyWith(
                  color: AppColors.status100,
                ),
              ),
              TextSpan(
                text: 'TOONDO',
                style: AppTypography.h2Bold.copyWith(
                  color: AppColors.green500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    final viewModel = context.read<WelcomeViewModel>();

    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 소셜 로그인 사용 시 주석 해제
          // AppGoogleLoginButton(
          //   onPressed: () => viewModel.continueWithGoogle(context),
          // ),
          // SizedBox(height: AppSpacing.v16),
          //
          // AppKakaoLoginButton(
          //   onPressed: () => viewModel.continueWithKakao(context),
          // ),
          // SizedBox(height: AppSpacing.v16),

          SizedBox(height: AppSpacing.v82), // 소셜 로그인 사용 시 주석 처리

          AppPhoneLoginButton(
            onPressed: () => viewModel.continueWithPhoneNumber(context),
          ),
        ],
    );
  }

  Widget _buildTermsText(BuildContext context) {
    final base = AppTypography.caption3Regular.copyWith(
      color: AppColors.green600,
    );
    final linkStyle = base.copyWith(
      decoration: TextDecoration.underline,
      decorationColor: AppColors.green600,
      fontWeight: FontWeight.w600,
    );
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: base,
            children: [
              const TextSpan(text: '버튼을 눌러 다음 화면으로 이동 시,\n'),
              TextSpan(
                text: '서비스 이용 약관',
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => LegalBottomSheet.show(
                        context,
                        title: '서비스 이용 약관',
                        content: LegalTexts.termsOfService,
                      ),
              ),
              const TextSpan(text: ' 및 '),
              TextSpan(
                text: '개인정보 수집 및 이용',
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => LegalBottomSheet.show(
                        context,
                        title: '개인정보 수집 및 이용',
                        content: LegalTexts.privacyPolicy,
                      ),
              ),
              const TextSpan(text: '에 동의한 것으로 간주합니다.'),
            ],
          ),
        ),
      ),
    );
  }
}
