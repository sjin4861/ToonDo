import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/todo/todo_input_viewmodel.dart';
import 'package:presentation/widgets/todo/common/eisenhower_button.dart';

class EisenhowerSelectorSection extends StatelessWidget {
  final TodoInputViewModel viewModel;

  const EisenhowerSelectorSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '아이젠하워',
          style: TextStyle(
            color: Color(0xFF1C1D1B),
            fontSize: 10,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index) => EisenhowerButton(
            index: index,
            isSelected: viewModel.selectedEisenhowerIndex == index,
            onTap: () => viewModel.setEisenhower(index),
          )),
        ),
      ],
    );
  }
}
