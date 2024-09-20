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
        title: Text('ToonDo'),
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              // TODO: 로그인 기능 구현 예정
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('로그인 기능은 추후에 제공될 예정입니다.')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 목표 리스트 표시
            Expanded(
              child: goalProvider.goals.isNotEmpty
                  ? ListView.builder(
                      itemCount: goalProvider.goals.length,
                      itemBuilder: (context, index) {
                        Goal goal = goalProvider.goals[index];
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              goal.name,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "기간: ${DateFormat('yyyy-MM-dd').format(goal.startDate)} ~ ${DateFormat('yyyy-MM-dd').format(goal.endDate)}",
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
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
                                } else if (value == 'delete') {
                                  goalProvider.deleteGoal(goal.id!);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('수정'),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text('삭제'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        '설정된 목표가 없습니다. 목표를 추가해보세요!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
            ),
            SizedBox(height: 16),
            // 목표 추가하기 버튼
            ElevatedButton.icon(
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
              icon: Icon(Icons.add),
              label: Text('목표 추가하기'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 16),
            // 기타 버튼들
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TodoSubmissionScreen()),
                      );
                    },
                    icon: Icon(Icons.list),
                    label: Text('투두리스트 작성'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GoalProgressScreen()),
                      );
                    },
                    icon: Icon(Icons.show_chart),
                    label: Text('목표 진행률'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EisenhowerMatrixScreen()),
                );
              },
              icon: Icon(Icons.grid_on),
              label: Text('아이젠하워 매트릭스'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}