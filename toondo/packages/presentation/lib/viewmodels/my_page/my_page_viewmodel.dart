// lib/viewmodels/my_page/my_page_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:domain/entities/user.dart';
import 'package:domain/usecases/todo/commit_todos.dart';
import 'package:domain/usecases/todo/fetch_todos.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class MyPageViewModel extends ChangeNotifier {
  final User currentUser;
  final CommitTodosUseCase commitTodosUseCase;
  final FetchTodosUseCase fetchTodosUseCase;

  MyPageViewModel({
    required this.currentUser,
    required this.commitTodosUseCase,
    required this.fetchTodosUseCase,
  });

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
}
