import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:provider/provider.dart';
import 'package:presentation/viewmodels/welcome/welcome_viewmodel.dart';
import 'package:presentation/views/welcome/welcome_body.dart';

const kWelcomeGradient = LinearGradient(
  begin: Alignment.bottomRight,
  end: Alignment.topLeft,
  transform: GradientRotation(2.933),
  colors: [
    Color(0xFFF8FFC5),
    Color(0xFFFDF8EB),
  ],
);

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WelcomeViewModel>(
      create: (_) => GetIt.instance<WelcomeViewModel>()..init(context),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: WelcomeGradientBackground(),
      ),
    );
  }
}

class WelcomeGradientBackground extends StatelessWidget {
  const WelcomeGradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: kWelcomeGradient),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontalPadding,
        ),
        child: const WelcomeBody(),
      ),
    );
  }
}
