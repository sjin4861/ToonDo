// screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/providers/goal_provider.dart';
import 'goal_input_screen.dart';
import 'goal_progress_screen.dart';
import 'todo_submission_screen.dart';
import 'eisenhower_matrix_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          // 목표 리스트 표시
          Expanded(
            child: ListView.builder(
              itemCount: goalProvider.goals.length,
              itemBuilder: (context, index) {
                Goal goal = goalProvider.goals[index];
                return ListTile(
                  title: Text(goal.name),
                  subtitle: Text(
                    "기간: ${DateFormat('yyyy-MM-dd').format(goal.startDate)} ~ ${DateFormat('yyyy-MM-dd').format(goal.endDate)}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // 목표 수정
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GoalInputScreen(
                                existingGoal: goal,
                                onGoalSet: (updatedGoal) {
                                  goalProvider.updateGoal(updatedGoal);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          goalProvider.deleteGoal(goal.id!);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // 목표 추가하기 버튼
          ElevatedButton(
            onPressed: () {
              if (goalProvider.goals.length >= 3) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('목표는 최대 3개까지 설정할 수 있습니다.')),
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GoalInputScreen(
                    onGoalSet: (newGoal) {
                      goalProvider.addGoal(newGoal);
                    },
                  ),
                ),
              );
            },
            child: Text('목표 추가하기'),
          ),
          // 기타 버튼들
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TodoSubmissionScreen()),
              );
            },
            child: Text('투두리스트 작성하기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GoalProgressScreen()),
              );
            },
            child: Text('목표 진행률 분석 보기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EisenhowerMatrixScreen()),
              );
            },
            child: Text('아이젠하워 매트릭스 보기'),
          ),
        ],
      ),
    );
  }
}