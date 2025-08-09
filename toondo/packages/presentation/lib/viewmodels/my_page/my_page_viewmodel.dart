import 'package:domain/usecases/auth/logout.dart';
import 'package:domain/usecases/user/get_user.dart';
import 'package:flutter/material.dart';
import 'package:domain/usecases/todo/commit_todos.dart';
import 'package:domain/usecases/todo/fetch_todos.dart';
import 'package:injectable/injectable.dart';
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
}

