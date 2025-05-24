import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/my_page/my_page_viewmodel.dart';
import 'my_page_scaffold.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyPageViewModel>(
      create: (_) => GetIt.instance<MyPageViewModel>(),
      child: const MyPageScaffold(),
    );
  }
}
