import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/my_page/account_setting/account_setting_viewmodel.dart';
import 'package:provider/provider.dart';

class NicknameChangeButton extends StatelessWidget {
  final TextEditingController controller;

  const NicknameChangeButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountSettingViewModel>(
      builder: (context, viewModel, child) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            backgroundColor: const Color(0xFF76B852),
          ),
          onPressed: viewModel.isLoading ? null : () async {
            print('[NicknameChangeButton] 변경 버튼 클릭: ${controller.text}');
            final success = await viewModel.updateNickname(controller.text);
            if (context.mounted) {
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('닉네임이 성공적으로 변경되었습니다.'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              } else {
                // 실패 시 에러 메시지 표시
                final errorMessage = viewModel.nicknameErrorMessage ?? '알 수 없는 오류가 발생했습니다.';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          child: viewModel.isLoading 
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white),
              )
            : const Text('변경하기'),
        );
      },
    );
  }
}

