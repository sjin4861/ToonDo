import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountSettingProfileSection extends StatelessWidget {
  const AccountSettingProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'assets/icons/mypage_icon.svg',
        width: 86,
        height: 86
      ),
    );
  }
}
