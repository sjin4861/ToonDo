import 'package:flutter/material.dart';

class AccountChangeTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final String? initialValue;

  const AccountChangeTextField({
    super.key,
    required this.label,
    this.hintText,
    this.enabled = true,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LabelText(label),
        const SizedBox(height: 12),
        _RoundedTextField(
          hintText: hintText,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          initialValue: initialValue,
        ),
      ],
    );
  }
}

class _LabelText extends StatelessWidget {
  final String label;

  const _LabelText(this.label);

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: textColor,
          fontFamily: 'Pretendard Variable',
      ),
    ),
    );
  }
}

class _RoundedTextField extends StatelessWidget {
  final String? hintText;
  final String? initialValue;
  final bool enabled;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;

  const _RoundedTextField({
    this.hintText,
    this.initialValue,
    this.enabled = true,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      enabled: enabled,
      keyboardType: keyboardType,
      cursorColor: const Color(0xFF78B545),
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: _inactiveBorder(),
        disabledBorder: _inactiveBorder(),
        focusedBorder: _activeBorder(),
      ),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFF1C1D1B),
        fontFamily: 'Pretendard Variable',
      ),
    );
  }

  OutlineInputBorder _inactiveBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
    );
  }

  OutlineInputBorder _activeBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: const BorderSide(color: Color(0xFF78B545)),
    );
  }
}
