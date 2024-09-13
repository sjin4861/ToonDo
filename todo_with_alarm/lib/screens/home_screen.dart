// screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/screens/todo_submission_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_with_alarm/services/goal_service.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:intl/intl.dart';
import 'goal_input_screen.dart';
import 'goal_progress_screen.dart'; // 목표 진행률 화면 임포트
import 'eisenhower_matrix_screen.dart'; // 아이젠하워 매트릭스 화면 임포트
import 'package:todo_with_alarm/services/notification_service.dart'; // NotificationService 임포트

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Goal> goals = []; // 설정된 목표 리스트

  // 알림 테스트를 위한 코드들
  final NotificationService _notificationService = NotificationService(); // 싱글톤 인스턴스 사용


  @override
  void initState() {
    super.initState();
    _loadGoals(); // 목표를 로드하는 함수 호출
  }

  // 목표를 로드하는 함수
  void _loadGoals() async {
    final loadedGoals = await GoalService.loadGoals(); // 설정된 목표 가져오기
    setState(() {
      goals = loadedGoals;
    });
  }

  // 목표를 추가하는 함수
  void _addGoal() async {
    if (goals.length >= 3) {
      Fluttertoast.showToast(
        msg: "목표는 최대 3개까지 설정할 수 있습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    // 목표 입력 화면으로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoalInputScreen(
          onGoalSet: (newGoal) {
            setState(() {
              goals.add(newGoal);
            });
            GoalService.saveGoals(goals);
          },
        ),
      ),
    );
  }

  // 목표를 수정하는 함수
  void _editGoal(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoalInputScreen(
          existingGoal: goals[index],
          onGoalSet: (updatedGoal) {
            setState(() {
              goals[index] = updatedGoal;
            });
            GoalService.saveGoals(goals);
          },
        ),
      ),
    );
  }

  // 목표를 삭제하는 함수
  void _deleteGoal(int index) {
    setState(() {
      goals.removeAt(index);
    });
    GoalService.saveGoals(goals);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 목표 리스트 표시
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                Goal goal = goals[index];
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
                        onPressed: () => _editGoal(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteGoal(index),
                      ),
                    ],
                  ),
                );
              },
            ),
            // 목표 추가하기 버튼
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _addGoal,
                child: Text('목표 추가하기'),
              ),
            ),
            // 투두리스트 작성하기 버튼
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TodoSubmissionScreen()),
                  );
                },
                child: Text('투두리스트 작성하기'),
              ),
            ),
            // 목표 진행률 분석 보기 버튼
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GoalProgressScreen()),
                  );
                },
                child: Text('목표 진행률 분석 보기'),
              ),
            ),
            // 아이젠하워 매트릭스 보기 버튼
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EisenhowerMatrixScreen()),
                  );
                },
                child: Text('아이젠하워 매트릭스 보기'),
              ),
            ),

            // 알림 테스트용 버튼임 (테스트 후 삭제 가능)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  await _notificationService.showWeeklyGoalProgressNotificationNow();
                },
                child: Text('주간 목표 진행률 알림 테스트'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  await _notificationService.showDailyTodoReminderNow();
                },
                child: Text('투두리스트 제출 독려 알림 테스트'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  await _notificationService.showDailyImportantTasksNotificationNow();
                },
                child: Text('아이젠하워 매트릭스 알림 테스트'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}