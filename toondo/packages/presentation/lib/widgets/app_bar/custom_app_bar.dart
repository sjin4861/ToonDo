import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFCFCFC),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1C1D1B)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      centerTitle: false,
      titleSpacing: 1.0,
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1C1D1B),
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.24,
          fontFamily: 'Pretendard Variable',
        ),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(0.5),
        child: Divider(color: Color(0x3F1C1D1B), height: 0.5, thickness: 0.5),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 0.5);
}
