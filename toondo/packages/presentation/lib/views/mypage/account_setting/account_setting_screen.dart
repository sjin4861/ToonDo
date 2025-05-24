import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/my_page/account_setting/account_setting_viewmodel.dart';
import 'package:presentation/views/mypage/account_setting/account_setting_scaffold.dart';
import 'package:provider/provider.dart';

class AccountSettingScreen extends StatelessWidget {
  const AccountSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AccountSettingViewModel>(
      create: (_) {
        final vm = GetIt.instance<AccountSettingViewModel>();
        vm.loadUser();
        return vm;
      },
      child: const AccountSettingScaffold(),
    );
  }
}
