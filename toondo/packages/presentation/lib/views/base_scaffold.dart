import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/navbars/app_nav_bar.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';

class BaseScaffold extends StatelessWidget {
  final PreferredSizeWidget? customAppBar;
  final String? title;
  final Widget body;
  final Widget? bottomWidget;

  const BaseScaffold({
    super.key,
    this.customAppBar,
    this.title,
    required this.body,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          customAppBar ??
          AppNavBar(
            title: title!,
            onBack: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontalPadding,
        ),
        child: body,
      ),
      bottomNavigationBar: bottomWidget,
    );
  }
}
