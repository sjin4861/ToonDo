import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/buttons/app_button.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/viewmodels/my_page/account_setting/account_setting_viewmodel.dart';
import 'package:presentation/views/base_scaffold.dart';
import 'package:presentation/views/mypage/account_setting/nickname_change_body.dart';
import 'package:provider/provider.dart';

class NicknameChangeScreen extends StatefulWidget {
  const NicknameChangeScreen({super.key});

  @override
  State<NicknameChangeScreen> createState() => _NicknameChangeScreenState();
}

class _NicknameChangeScreenState extends State<NicknameChangeScreen> {
  final TextEditingController _newNicknameController = TextEditingController();
  String? _nicknameError;

  @override
  void dispose() {
    _newNicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AccountSettingViewModel>();
    final currentNickname = viewModel.userUiModel?.displayName ?? '';

    return BaseScaffold(
      title: '닉네임 변경',
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: NicknameChangeBody(
                controller: _newNicknameController,
                currentNickname: currentNickname,
                errorText: _nicknameError,
                onChanged: (_) {
                  if (_nicknameError != null) {
                    setState(() {
                      _nicknameError = null;
                    });
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.v16),
            child: AppButton(
              label: '변경하기',
              onPressed: () async {
                final success = await viewModel.updateNickname(
                  _newNicknameController.text,
                );
                if (success && mounted) {
                  Navigator.pop(context);
                  return;
                }
                if (mounted) {
                  setState(() {
                    _nicknameError = viewModel.nicknameErrorMessage;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
