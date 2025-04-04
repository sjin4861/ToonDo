import 'package:flutter/material.dart';

class AccountSettingTile extends StatelessWidget {
  final String label;
  final String? value;

  const AccountSettingTile({super.key, required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1C1D1B),
            ),
          ),
          Row(
            children: [
              if (value != null)
                Text(
                  value!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff858584),
                  ),
                ),
              const SizedBox(width: 16),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFFD9D9D9),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
