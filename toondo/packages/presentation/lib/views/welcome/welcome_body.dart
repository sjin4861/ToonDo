import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:common/gen/assets.gen.dart';
import 'package:presentation/viewmodels/welcome/welcome_viewmodel.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/designsystem/components/buttons/app_google_login_button.dart';
import 'package:presentation/designsystem/components/buttons/app_kakao_login_button.dart';
import 'package:presentation/designsystem/components/buttons/app_phone_login_button.dart';

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
          _buildCharacterSection(),
          SizedBox(height: AppSpacing.v28),
          _buildWelcomeText(),
          SizedBox(height: AppSpacing.v52),
          _buildButtons(context),
          SizedBox(height: AppSpacing.v120),
          _buildTermsText(),
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
          AppGoogleLoginButton(
            onPressed: () => viewModel.continueWithGoogle(context),
          ),
          SizedBox(height: AppSpacing.v16),

          AppKakaoLoginButton(
            onPressed: () => viewModel.continueWithKakao(context),
          ),
          SizedBox(height: AppSpacing.v16),

          AppPhoneLoginButton(
            onPressed: () => viewModel.continueWithPhoneNumber(context),
          ),
        ],
    );
  }

  Widget _buildTermsText() {
    return Text(
        '버튼을 눌러 다음 화면으로 이동 시,\n서비스 이용 약관 및 개인정보 처리 방안에 동의한 것으로 간주합니다.',
        textAlign: TextAlign.center,
        style: AppTypography.caption3Regular.copyWith(
          color: AppColors.green600
        ),
    );
  }
}
