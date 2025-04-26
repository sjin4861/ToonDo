import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presentation/widgets/my_page/account_setting/profile_change_botttom_sheet.dart';

class AccountSettingProfileSection extends StatelessWidget {
  const AccountSettingProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) => const ProfileChangeBotttomSheet(),
          );
        },
        child: SvgPicture.asset(
          'assets/icons/img_profile_default.svg',
          width: 86,
          height: 86,
        ),
      ),
    );
  }
}
