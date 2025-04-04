import 'package:flutter/material.dart';
import 'package:presentation/navigation/route_paths.dart';
import 'my_page_setting_tile.dart';

class MyPageSettingSection extends StatelessWidget {
  const MyPageSettingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('설정', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        const MyPageSettingTile(title: '동기화'),
        MyPageSettingTile(
          title: '화면',
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFFD9D9D9),
          ),
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.displaySetting);
          },
        ),
        MyPageSettingTile(
          title: '소리/알림',
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFFD9D9D9),
          ),
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.notificationSetting);
          },
        ),
        MyPageSettingTile(
          title: '계정관리',
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFFD9D9D9),
          ),
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.accountSetting);
          },
        ),
        MyPageSettingTile(
          title: '이용안내',
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFFD9D9D9),
          ),
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.helpGuide);
          },
        ),
      ],
    );
  }
}
