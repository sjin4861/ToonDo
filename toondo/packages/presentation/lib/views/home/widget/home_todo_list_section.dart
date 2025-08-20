import 'package:domain/entities/todo.dart';
import 'package:flutter/material.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/views/home/widget/home_list_item.dart';

class HomeTodoListSection extends StatelessWidget {
  final List<Todo> todos;

  const HomeTodoListSection({
    super.key,
    required this.todos,
  });

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: AppSpacing.spacing32),
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            '설정된 투두가 없습니다. 투두를 추가해보세요!',
            style: AppTypography.h3Regular.copyWith(
              color: Colors.grey
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: todos.map((todo) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: AppSpacing.spacing12,
            ),
            child: HomeListItem(
              todo: todo,
            ),
          );
        }).toList(),
      ),
    );
  }
}
