import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/my_page/display_setting/display_setting_viewmodel.dart';
import 'package:provider/provider.dart';
import 'display_setting_scaffold.dart';

class DisplaySettingScreen extends StatelessWidget {
  const DisplaySettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DisplaySettingViewModel>(
      create: (_) {
        final vm = GetIt.instance<DisplaySettingViewModel>();
        vm.load();
        return vm;
      },
      child: const DisplaySettingScaffold(),
    );
  }
}
