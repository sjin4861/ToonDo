import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/my_page/help_guide/help_guide_viewmodel.dart';
import 'package:provider/provider.dart';
import 'help_guide_scaffold.dart';

class HelpGuideScreen extends StatelessWidget {
  const HelpGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GetIt.instance<HelpGuideViewModel>(),
      child: const HelpGuideScaffold(),
    );
  }
}
