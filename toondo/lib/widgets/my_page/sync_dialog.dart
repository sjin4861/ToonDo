import 'package:flutter/material.dart';
import 'package:toondo/viewmodels/my_page/my_page_viewmodel.dart';

class SyncDialog extends StatelessWidget {
  final MyPageViewModel viewModel;

  const SyncDialog({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('동기화 대상 확인'),
      content: FutureBuilder<Map<String, int>>(
        future: _fetchSyncCounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 80,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Text('오류 발생: ${snapshot.error}');
          }
          final counts = snapshot.data!;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('미동기화 Todo: ${counts['todos'] ?? 0}건'),
              const SizedBox(height: 8),
              Text('미동기화 Goal: ${counts['goals'] ?? 0}건'),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('서버로 동기화'),
        ),
      ],
    );
  }

  Future<Map<String, int>> _fetchSyncCounts() async {
    // viewModel을 이용해서 동기화되지 않은 항목들의 개수를 가져옵니다.
    int unsyncedTodos = await viewModel.todoService.getUnsyncedTodosCount();
    int unsyncedGoals = await viewModel.goalService.getUnsyncedGoalsCount();
    return {'todos': unsyncedTodos, 'goals': unsyncedGoals};
  }
}