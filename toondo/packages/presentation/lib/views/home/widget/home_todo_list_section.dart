import 'package:domain/entities/status.dart';
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
    final List<Todo> todos = [
      Todo(
        id: '1',
        title: '운동 30분 하기',
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 2)),
        importance: 1,
        urgency: 1,
        status: 20,
        goalId: null,
      ),
      Todo(
        id: '2',
        title: '책 20페이지 읽기',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 5)),
        importance: 0,
        urgency: 1,
        status: 30,
        goalId: null,
      ),
      Todo(
        id: '3',
        title: '친구에게 연락하기',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 1)),
        importance: 0,
        urgency: 0,
        status: 80,
        goalId: null,
      ),
    ];


    if (todos.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: AppSpacing.spacing40),
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
            padding: const EdgeInsets.only(
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
