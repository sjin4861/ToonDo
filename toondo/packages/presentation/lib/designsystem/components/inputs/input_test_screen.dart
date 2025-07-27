import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/buttons/app_button.dart';
import 'package:presentation/designsystem/components/chips/chip_test_screen.dart';
import 'package:presentation/designsystem/components/navbars/app_nav_bar.dart';
import 'app_input_field.dart';
import 'app_date_field.dart';

class InputTestScreen extends StatefulWidget {
  const InputTestScreen({super.key});

  @override
  State<InputTestScreen> createState() => _InputTestScreenState();
}

class _InputTestScreenState extends State<InputTestScreen> {
  final TextEditingController _defaultController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _errorController = TextEditingController();

  bool _showPassword = false;
  DateTime? _selectedDate;
  bool _showDateError = false;

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _showDateError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        title: 'input field test',
        onBack: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('✅ 기본 입력 필드'),
              const SizedBox(height: 8),
              AppInputField(
                label: 'caption',
                hintText: 'placeholder',
                controller: _defaultController,
              ),
              const SizedBox(height: 24),

              const Text('🔒 비밀번호 입력 필드'),
              const SizedBox(height: 8),
              AppInputField(
                label: 'caption',
                hintText: 'placeholder',
                controller: _passwordController,
                obscureText: !_showPassword,
                showToggleVisibility: true,
                onToggleVisibility: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              ),
              const SizedBox(height: 24),

              const Text('❌ 에러 상태 필드'),
              const SizedBox(height: 8),
              AppInputField(
                label: 'caption',
                hintText: 'placeholder',
                controller: _errorController,
                errorText: _errorController.text.length < 3 ? 'error' : null,
              ),
              const SizedBox(height: 24),

              const Text('📅 날짜 선택 필드'),
              const SizedBox(height: 8),
              AppDateField(
                label: '시작일',
                date: _selectedDate,
                showError: _showDateError,
                onTap: _selectDate,
              ),
              const SizedBox(height: 100), // 공간 확보용
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: AppButton(
          label: '다음으로',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChipTestScreen()),
            );
          },
          size: AppButtonSize.large,
          isEnabled: true,
        ),
      ),
    );
  }
}
