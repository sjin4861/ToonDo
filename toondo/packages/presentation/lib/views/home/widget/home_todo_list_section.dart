import 'package:domain/entities/todo.dart';
import 'package:domain/entities/goal.dart';
import 'package:flutter/material.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/views/home/widget/home_list_item.dart';

class HomeTodoListSection extends StatelessWidget {
  final List<Todo> todos;
  final List<Goal>? allGoals; // 아이콘 표시를 위한 목표 리스트 추가

  const HomeTodoListSection({
    super.key,
    required this.todos,
    this.allGoals, // 선택사항으로 목표 리스트 받기
  });

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: AppSpacing.v32),
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            // 메인화면 투두 리스트 표시 규칙 개선 - 빈 상태 메시지 수정
            '오늘 할 투두가 없습니다.\n투두를 추가하거나 우선순위를 설정해보세요!',
            style: AppTypography.h3Regular.copyWith(
              color: Colors.grey
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // 메인화면 투두 리스트 표시 규칙 개선 - 우선순위 표시 기능 추가
    // 1. eisenhower 매트릭스 기반 우선순위 배지 표시
    // 2. 긴급/중요 여부에 따른 색상 구분
    // 3. 완료율 표시 개선
    return SingleChildScrollView(
      child: Column(
        children: todos.map((todo) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: AppSpacing.v12,
            ),
            child: HomeListItem(
              todo: todo,
              allGoals: allGoals, // 목표 리스트 전달하여 아이콘 표시 가능하도록 수정
            ),
          );
        }).toList(),
      ),
    );
  }
}
