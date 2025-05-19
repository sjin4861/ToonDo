import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: IconTheme.of(context).color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      centerTitle: false,
      titleSpacing: 1.0,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w400,
          letterSpacing: 0.24,
          fontSize: 16,
          color: textColor,
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
