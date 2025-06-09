import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/todo/todo_input_viewmodel.dart';

class TodoTitleSection extends StatelessWidget {
  final TodoInputViewModel viewModel;

  const TodoTitleSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '투두 이름',
          style: TextStyle(
            color: Color(0xFF1C1D1B),
            fontSize: 10,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1000),
              side: BorderSide(
                width: 1,
                color: viewModel.isTitleNotEmpty ? const Color(0xFF78B545) : const Color(0xFFDDDDDD),
              ),
            ),
          ),
          child: TextFormField(
            controller: viewModel.titleController,
            maxLength: 20,
            cursorColor: const Color(0xFF78B545),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              hintText: '투두의 이름을 입력하세요.',
              contentPadding: EdgeInsets.only(bottom: 8),
              hintStyle: TextStyle(
                color: Color(0xFFB2B2B2),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.18,
              ),
            ),
            style: const TextStyle(
              color: Color(0xFF1C1D1B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.18,
            ),
            onSaved: (value) => viewModel.title = (value ?? '').trim(),
          ),
        ),
        if (viewModel.titleError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Text(
              viewModel.titleError!,
              style: const TextStyle(
                color: Color(0xFFEE0F12),
                fontSize: 10,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.15,
              ),
            ),
          ),
      ],
    );
  }
}