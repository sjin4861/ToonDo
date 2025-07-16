import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/my_page/account_setting/account_setting_viewmodel.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/my_page/account_setting/account_change_title.dart';
import 'package:presentation/widgets/my_page/account_setting/account_change_text_field.dart';
import 'package:provider/provider.dart';

class PhoneNumberChangeScreen extends StatelessWidget {
  const PhoneNumberChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AccountSettingViewModel>();
    final currentPhoneNumber = viewModel.userUiModel?.phoneNumber ?? '등록된 휴대전화 번호가 없습니다';
    final phoneController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: '휴대전화 변경'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const AccountChangeTitle(value: '휴대전화'),
            const SizedBox(height: 28),
            AccountChangeTextField(
              label: '기존 휴대전화',
              enabled: false,
              initialValue: currentPhoneNumber,
            ),
            const SizedBox(height: 24),
            Consumer<AccountSettingViewModel>(
              builder: (context, vm, child) {
                return AccountChangeTextField(
                  label: '새 휴대전화',
                  hintText: '010-1234-5678',
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  errorText: vm.phoneNumberErrorMessage,
                );
              },
            ),
            const Spacer(),
            Consumer<AccountSettingViewModel>(
              builder: (context, vm, child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    backgroundColor: const Color(0xFF76B852),
                  ),
                  onPressed: vm.isLoading ? null : () async {
                    final success = await vm.updatePhoneNumber(phoneController.text);
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('휴대전화 번호가 성공적으로 변경되었습니다.')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: vm.isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text('변경하기'),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
