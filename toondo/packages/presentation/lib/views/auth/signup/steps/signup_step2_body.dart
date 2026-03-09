import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/inputs/app_input_field.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';
import 'package:provider/provider.dart';

class SignupStep2Body extends StatefulWidget {
  const SignupStep2Body({super.key});

  @override
  State<SignupStep2Body> createState() => _SignupStep2BodyState();
}

class _SignupStep2BodyState extends State<SignupStep2Body> {
  final _passwordFocusNode = FocusNode();
  final _confirmFieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(_onPasswordFocus);
  }

  void _onPasswordFocus() {
    if (!_passwordFocusNode.hasFocus) return;
    // 키보드 애니메이션(~300ms) 완료 후 호출해야 정확한 레이아웃 기준으로 스크롤됨
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      final ctx = _confirmFieldKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
        );
      }
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.removeListener(_onPasswordFocus);
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignupViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSpacing.v64),
        _buildHeaderText(),
        SizedBox(height: AppSpacing.v56),
        AppInputField(
          label: '비밀번호',
          focusNode: _passwordFocusNode,
          controller: viewModel.passwordTextController,
          hintText: '영문, 숫자 조합 8~20자로 입력해주세요',
          obscureText: viewModel.isPasswordObscured,
          showToggleVisibility: true,
          onToggleVisibility: () => viewModel.togglePasswordVisibility(),
          errorText: viewModel.passwordError,
          onChanged: (value) => viewModel.setPassword(value),
        ),
        SizedBox(height: AppSpacing.v24),
        AppInputField(
          key: _confirmFieldKey,
          label: '비밀번호 확인',
          controller: viewModel.confirmPasswordTextController,
          hintText: '영문, 숫자 조합 8~20자로 입력해주세요',
          obscureText: viewModel.isConfirmPasswordObscured,
          showToggleVisibility: true,
          onToggleVisibility: () => viewModel.toggleConfirmPasswordVisibility(),
          errorText: viewModel.confirmPasswordError,
          onChanged: (value) => viewModel.setConfirmPassword(value),
        ),
      ],
    );
  }

  Widget _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '툰두와 처음 만나셨네요! 👋🏻',
          style: AppTypography.h2Bold.copyWith(color: AppColors.green500),
        ),
        SizedBox(height: AppSpacing.v8),
        Text(
          '영문과 숫자를 조합한 8~20자의 비밀번호를 만들어주세요.',
          style: AppTypography.caption1Regular.copyWith(
            color: AppColors.status100_75,
          ),
        ),
      ],
    );
  }
}
