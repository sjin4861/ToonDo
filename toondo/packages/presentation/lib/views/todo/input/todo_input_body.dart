import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/todo/todo_input_viewmodel.dart';
import 'package:presentation/widgets/text_fields/tip.dart';
import 'package:presentation/widgets/todo/input/date_selection_section.dart';
import 'package:presentation/widgets/todo/input/dday_daily_chip_section.dart';
import 'package:presentation/widgets/todo/input/eisenhower_selector_section.dart';
import 'package:presentation/widgets/todo/input/goal_selection_section.dart';
import 'package:presentation/widgets/todo/input/todo_title_section.dart';
import 'package:provider/provider.dart';

class TodoInputBody extends StatelessWidget {
  const TodoInputBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TodoInputViewModel>();

    return SingleChildScrollView(
      child: Form(
        key: viewModel.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DdayDailyChipSection(viewModel: viewModel),
            const SizedBox(height: 20),
            TodoTitleSection(viewModel: viewModel),
            const SizedBox(height: 24),
            GoalSelectionSection(viewModel: viewModel),
            const SizedBox(height: 24),
            DateSelectionSection(viewModel: viewModel),
            const SizedBox(height: 24),
            EisenhowerSelectorSection(viewModel: viewModel),
            const SizedBox(height: 24),
            const TipWidget(
              title: 'TIP',
              description: '아이젠하워는 긴급도와 중요도에 따라 할 일을 정리하는 방법이에요.\n'
                  '앞으로 투두가 아이젠하워에 따라 가장 중요한 일부터 알려줄게요!',
            ),
          ],
        ),
      ),
    );
  }
}
