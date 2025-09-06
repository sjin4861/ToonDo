import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/designsystem/components/buttons/double_action_buttons.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/viewmodels/settings/delete_account_viewmodel.dart';
import 'package:presentation/views/base_scaffold.dart';
import 'package:presentation/views/mypage/account_setting/delete_account_body.dart';
import 'package:presentation/views/welcome/welcome_screen.dart';
import 'package:provider/provider.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DeleteAccountViewModel>.value(
      value: GetIt.instance<DeleteAccountViewModel>(),
      child: Consumer<DeleteAccountViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isDeleted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                    (route) => false,
              );
            });
          }

          return BaseScaffold(
            title: '계정 탈퇴',
            body: const DeleteAccountBody(),
            bottomWidget: SafeArea(
              minimum: EdgeInsets.all(AppSpacing.a24),
              child: DoubleActionButtons(
                backText: '취소',
                nextText: '탈퇴하기',
                onBack: viewModel.isLoading ? null : () => Navigator.pop(context),
                onNext: viewModel.isLoading
                    ? null
                    : () => _showDeleteConfirmDialog(context, viewModel),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, DeleteAccountViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            '최종 확인',
            style: TextStyle(
              color: Color(0xFF1C1D1B),
              fontSize: 18,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            '정말로 계정을 탈퇴하시겠습니까?\n\n이 작업은 되돌릴 수 없습니다.',
            style: TextStyle(
              color: Color(0xFF1C1D1B),
              fontSize: 14,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '취소',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await viewModel.deleteAccount();
              },
              child: const Text(
                '탈퇴',
                style: TextStyle(
                  color: Color(0xFFEE0F12),
                  fontSize: 14,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
