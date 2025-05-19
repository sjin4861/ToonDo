import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/my_page/my_page_viewmodel.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/my_page/my_page_profile_section.dart';
import 'package:presentation/widgets/my_page/my_page_setting_section.dart';
import 'package:provider/provider.dart';

class MyPageScaffold extends StatefulWidget {
  const MyPageScaffold({super.key});

  @override
  State<MyPageScaffold> createState() => _MyPageScaffoldState();
}

class _MyPageScaffoldState extends State<MyPageScaffold> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyPageViewModel>().loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(title: '마이페이지'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 30),
              MyPageProfileSection(),
              SizedBox(height: 32),
              Divider(color: Color(0xFFDADADA), height: 1),
              SizedBox(height: 32),
              MyPageSettingSection(),
            ],
          ),
        ),
      ),
    );
  }
}
