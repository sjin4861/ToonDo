import 'package:flutter/material.dart';
import 'package:presentation/views/home/home_body.dart';
import 'package:presentation/widgets/home/home_app_bar.dart';
import 'package:presentation/widgets/navigation/bottom_navigation_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';

class HomeScaffold extends StatelessWidget {
  final bool isNewLogin;
  const HomeScaffold({super.key, required this.isNewLogin});

  @override
  Widget build(BuildContext context) {
    final homeVM = context.watch<HomeViewModel>();

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      appBar: HomeAppBar(chatEnabled: homeVM.chatEnabled),
      body: const HomeBody(),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}

