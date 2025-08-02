import 'package:flutter/material.dart';
import 'package:presentation/views/base_scaffold.dart';
import 'package:presentation/views/mypage/my_page_body.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/my_page/my_page_viewmodel.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyPageViewModel>(
      create: (_) => GetIt.instance<MyPageViewModel>(),
      child: BaseScaffold(title: '마이페이지', body: MyPageBody()),
    );
  }
}
