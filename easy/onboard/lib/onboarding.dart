import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'main.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
            title: 'Welcome to my app',
            body: 'This is the first page.',
            image: Image.asset('image/page1.png'),
            decoration: const PageDecoration()),
        PageViewModel(
            title: 'Welcome to my app', body: 'This is the first page.'),
        PageViewModel(
            title: 'Welcome to my app', body: 'This is the first page.')
      ],
      done: const Text('done'),
      onDone: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const MyPage()),
        );
      },
      next: const Icon(Icons.arrow_forward),
    );
  }
}
