import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';
import 'home_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>.value(
      value: GetIt.instance<HomeViewModel>(),
      child: const HomeScaffold(),
    );
  }
}
