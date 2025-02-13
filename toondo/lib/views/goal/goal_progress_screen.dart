// screens/goal_progress_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toondo/data/models/goal.dart';
import 'package:toondo/viewmodels/goal/goal_viewmodel.dart';
import 'package:intl/intl.dart';

class GoalProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final goalViewModel = Provider.of<GoalViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('목표 진행률'),
      ),
      body: goalViewModel.goals.isNotEmpty
          ? ListView.builder(
              itemCount: goalViewModel.goals.length,
              itemBuilder: (context, index) {
                Goal goal = goalViewModel.goals[index];
                double expectedProgress = goal.getExpectedProgress();

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 목표 이름 표시
                        Text(
                          goal.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        // 기대 진행률 표시
                        Text(
                          '기대 진행률: ${expectedProgress.toStringAsFixed(1)}%',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        LinearProgressIndicator(
                          value: expectedProgress / 100,
                          backgroundColor: Colors.grey[300],
                          color: Colors.blue[300],
                        ),
                        SizedBox(height: 8),
                        // 실제 진행률 표시
                        Text(
                          '현재 진행률: ${goal.progress.toStringAsFixed(1)}%',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        LinearProgressIndicator(
                          value: goal.progress / 100,
                          backgroundColor: Colors.grey[300],
                          color: Colors.green[400],
                        ),
                        SizedBox(height: 16),
                        // 진행률 조정 슬라이더
                        Text('진행률 조정'),
                        Slider(
                          value: goal.progress,
                          min: 0.0,
                          max: 100.0,
                          divisions: 1000, // 0.1% 단위
                          label: '${goal.progress.toStringAsFixed(1)}%',
                          onChanged: (double value) {
                            // ViewModel을 통해 목표의 진행률 업데이트
                            goalViewModel.updateGoalProgress(goal.id!, value);
                          },
                        ),
                        // 목표 기간 표시
                        Text(
                          '기간: ${DateFormat('yyyy-MM-dd').format(goal.startDate)} ~ ${DateFormat('yyyy-MM-dd').format(goal.endDate)}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text('설정된 목표가 없습니다.'),
            ),
    );
  }
}