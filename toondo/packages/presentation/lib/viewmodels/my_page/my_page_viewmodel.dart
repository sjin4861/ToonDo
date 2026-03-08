import 'dart:convert';
import 'dart:io';
import 'package:data/constants.dart';
import 'package:domain/usecases/goal/get_goals_local.dart';
import 'package:domain/usecases/auth/logout.dart';
import 'package:domain/usecases/user/get_user.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:domain/usecases/todo/commit_todos.dart';
import 'package:domain/usecases/todo/fetch_todos.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:presentation/models/my_page_user_ui_model.dart';

@injectable
class MyPageViewModel extends ChangeNotifier {
  final GetUserUseCase getUserUseCase;
  final CommitTodosUseCase commitTodosUseCase;
  final FetchTodosUseCase fetchTodosUseCase;
  final LogoutUseCase logoutUseCase;

  MyPageViewModel({
    required this.getUserUseCase,
    required this.commitTodosUseCase,
    required this.fetchTodosUseCase,
    required this.logoutUseCase,
  }){
    loadUser();
  }

  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  MyPageUserUiModel? _userUiModel;

  MyPageUserUiModel? get userUiModel => _userUiModel;

  Future<void> loadUser() async {
    _isLoading = true;

    try {
      final user = await getUserUseCase();
      _userUiModel = MyPageUserUiModel.fromDomain(user);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = '유저 정보를 불러오는 데 실패했습니다.';
    } finally {
      _isLoading = false;
    }
  }


  Future<void> fetchTodoOnly() async {
    try {
      await fetchTodosUseCase();
    } catch (e) {
      print('Error fetching todo only: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> commitTodoOnly() async {
    try {
      await commitTodosUseCase();
    } catch (e) {
      print('Error committing todo only: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await logoutUseCase();
    } catch (e) {
      debugPrint('로그아웃 실패: $e');
    }
  }

  Future<TodoTraceExportResult> exportTodoTraceLocally() async {
    _isLoading = true;
    notifyListeners();

    try {
      final todos = await fetchTodosUseCase();
      final goals = await GetIt.I<GetGoalsLocalUseCase>()();
      final user = await getUserUseCase();

      final payload = {
        'meta': {
          'generatedAt': DateTime.now().toIso8601String(),
          'dataMode': Constants.localDbOnlyMode ? 'local_db' : 'remote_api',
          'appPurpose': 'todo_trace_export',
        },
        'user': {
          'id': user.id,
          'loginId': user.loginId,
          'nickname': user.nickname,
          'createdAt': user.createdAt.toIso8601String(),
        },
        'summary': {
          'todoCount': todos.length,
          'goalCount': goals.length,
        },
        'goals': goals
            .map(
              (g) => {
                'id': g.id,
                'name': g.name,
                'icon': g.icon,
                'progress': g.progress,
                'startDate': g.startDate.toIso8601String(),
                'endDate': g.endDate?.toIso8601String(),
                'showOnHome': g.showOnHome,
                'status': g.status.name,
              },
            )
            .toList(),
        'todos': todos
            .map(
              (t) => {
                'id': t.id,
                'title': t.title,
                'goalId': t.goalId,
                'status': t.status,
                'comment': t.comment,
                'startDate': t.startDate.toIso8601String(),
                'endDate': t.endDate.toIso8601String(),
                'eisenhower': t.eisenhower,
                'showOnHome': t.showOnHome,
              },
            )
            .toList(),
      };

      final file = await _writeTraceFile(payload);

      return TodoTraceExportResult(
        success: true,
        message: '데이터 파일을 로컬에 저장했습니다. 파일 앱에서 수동으로 Drive에 업로드해주세요.',
        localFilePath: file.path,
        localFileName: file.uri.pathSegments.last,
      );
    } catch (e) {
      return TodoTraceExportResult(success: false, message: '데이터 내보내기 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<File> _writeTraceFile(Map<String, dynamic> payload) async {
    final exportDirectory = await _getExportDirectory();
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    final file = File('${exportDirectory.path}/toondo_trace_$timestamp.json');
    final encoder = const JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(payload));
    return file;
  }

  Future<Directory> _getExportDirectory() async {
    Directory? baseDirectory;
    if (Platform.isAndroid) {
      baseDirectory = await getExternalStorageDirectory();
    }
    baseDirectory ??= await getApplicationDocumentsDirectory();

    final exportDirectory = Directory('${baseDirectory.path}/toondo_exports');
    if (!await exportDirectory.exists()) {
      await exportDirectory.create(recursive: true);
    }
    return exportDirectory;
  }
}

class TodoTraceExportResult {
  final bool success;
  final String message;
  final String? localFilePath;
  final String? localFileName;

  TodoTraceExportResult({
    required this.success,
    required this.message,
    this.localFilePath,
    this.localFileName,
  });
}

