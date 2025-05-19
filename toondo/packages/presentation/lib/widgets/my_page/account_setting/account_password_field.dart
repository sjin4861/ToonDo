import 'package:flutter/material.dart';

class AccountPasswordField extends StatefulWidget {
  final String label;
  final String? hintText;
  final String? errorText;
  final TextEditingController controller;

  const AccountPasswordField({
    super.key,
    required this.label,
    this.hintText,
    this.errorText,
    required this.controller,
  });
  
  @override
  State<AccountPasswordField> createState() => _AccountPasswordFieldState();
}

class _AccountPasswordFieldState extends State<AccountPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final textColor = widget.errorText != null
        ? Colors.red
        : Theme.of(context).textTheme.bodyMedium?.color;
    final borderColor =
    widget.errorText != null ? Colors.red : const Color(0xFFDDDDDD);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: textColor,
            fontFamily: 'Pretendard Variable',
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFFCCCCCC),
              ),
              onPressed: () {
                setState(() => _obscureText = !_obscureText);
              },
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: _buildBorder(borderColor),
            focusedBorder: _buildBorder(borderColor),
            errorBorder: _buildBorder(Colors.red),
            focusedErrorBorder: _buildBorder(Colors.red),
          ),
          style: const TextStyle(fontSize: 14),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText!,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.red,
              fontFamily: 'Pretendard Variable',
            ),
          ),
        ]
      ],
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide(color: color),
    );
  }
}
