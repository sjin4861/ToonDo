import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/viewmodels/onboarding/onboarding_viewmodel.dart';
import 'package:provider/provider.dart';

class OnboardingStep1To2Body extends StatelessWidget {
  const OnboardingStep1To2Body({super.key});

  @override
  Widget build(BuildContext context) {
    final step = context.watch<OnboardingViewModel>().step;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 258),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Text(
            step == 1
                ? '🎉 축하해요!\n계정이 만들어졌어요'
                : '반가워요!\n제 이름은 슬라임이에요 😄',
            key: ValueKey(step),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.green500,
            ),
          ),
        ),
      ),
    );
  }
}
