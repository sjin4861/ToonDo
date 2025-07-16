import 'package:flutter/material.dart';
import 'package:presentation/views/home/home_body.dart';
import 'package:presentation/widgets/home/home_app_bar.dart';
import 'package:presentation/widgets/navigation/bottom_navigation_bar_widget.dart';

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      appBar: const HomeAppBar(),
      body: const HomeBody(),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}

