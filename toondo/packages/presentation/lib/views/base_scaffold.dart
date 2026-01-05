import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/navbars/app_nav_bar.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';

class BaseScaffold extends StatelessWidget {
  final PreferredSizeWidget? customAppBar;
  final String? title;
  final Widget body;
  final Widget? bottomWidget;
  final bool extendBody;
  final bool showBackButton;

  const BaseScaffold({
    super.key,
    this.customAppBar,
    this.title,
    required this.body,
    this.bottomWidget,
    this.extendBody = false,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final Widget content = extendBody
        ? body
        : Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontalPadding,
            ),
            child: body,
          );

    return Scaffold(
      appBar: customAppBar ??
          (title != null
              ? AppNavBar(
                  title: title!,
                  showBackButton: showBackButton,
                  onBack: () {
                    Navigator.pop(context);
                  },
                )
              : null),
      body: SafeArea(
        bottom: true,
        child: content,
      ),
      bottomNavigationBar: bottomWidget == null
          ? null
          : SafeArea(
              top: false,
              child: bottomWidget!,
            ),
    );
  }
}
