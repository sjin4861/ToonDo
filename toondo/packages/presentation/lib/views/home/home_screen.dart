import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/navigation/bottom_navigation_bar_widget.dart';
import 'package:presentation/views/home/home_body.dart';
import 'package:presentation/views/home/widget/home_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>.value(
      value: GetIt.instance<HomeViewModel>(),
      child: const Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: HomeAppBar(),
        body: HomeBody(),
        bottomNavigationBar: BottomNavigationBarWidget(),
      ),
    );
  }
}
