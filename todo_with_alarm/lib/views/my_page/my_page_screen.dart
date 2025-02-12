// lib/views/my_page/my_page_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/data/models/user.dart';
import 'package:todo_with_alarm/services/goal_service.dart';
import 'package:todo_with_alarm/services/todo_service.dart';
import 'package:todo_with_alarm/viewmodels/my_page/my_page_viewmodel.dart';
import 'package:todo_with_alarm/widgets/my_page/sync_dialog.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 현재 로그인한 사용자의 정보를 Hive에서 가져옵니다.
    // (예: 'currentUser' 키로 저장되어 있다고 가정)
    final Box<User> userBox = Hive.box<User>('user');
    final User? currentUser = userBox.get('currentUser');

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('마이페이지')),
        body: const Center(child: Text('사용자 정보가 없습니다.')),
      );
    }
    // MultiProvider에서 이미 TodoService와 GoalService가 등록되어 있으므로
    // Provider.of를 통해 인스턴스를 가져올 수 있습니다.
    final todoService = Provider.of<TodoService>(context, listen: false);
    final goalService = Provider.of<GoalService>(context, listen: false);
    
    return ChangeNotifierProvider<MyPageViewModel>(
      create: (_) => MyPageViewModel(
        currentUser: currentUser,
        todoService: todoService,
        goalService: goalService,
      ),
      child: Consumer<MyPageViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('마이페이지'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '안녕하세요, ${viewModel.currentUser.username ?? '사용자'}님!',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  // 기타 마이페이지 내용(예: 내 포인트, 내 정보 등)을 여기에 추가
                  const Spacer(),
                  // 동기화하기 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final myPageViewModel = Provider.of<MyPageViewModel>(context, listen: false);
                        // 다이얼로그 호출 시 viewModel 전달
                        final bool? confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => SyncDialog(viewModel: myPageViewModel),
                        );
                        if (confirmed == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('동기화가 완료되었습니다.')),
                          );
                        }
                      },
                      child: const Text('동기화하기'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => viewModel.fetchTodoOnly(),
                      child: const Text('Fetch Todo'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => viewModel.commitTodoOnly(),
                      child: const Text('Commit Todo'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}