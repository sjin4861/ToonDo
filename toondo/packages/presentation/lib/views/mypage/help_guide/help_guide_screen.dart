import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/my_page/help_guide/help_guide_viewmodel.dart';
import 'package:presentation/views/base_scaffold.dart';
import 'package:presentation/views/mypage/help_guide/help_guide_body.dart';
import 'package:provider/provider.dart';

class HelpGuideScreen extends StatelessWidget {
  const HelpGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GetIt.instance<HelpGuideViewModel>(),
      child: BaseScaffold(title: '이용안내', body: HelpGuideBody()),
    );
  }
}
