import 'package:data/models/goal_model.dart';
import 'package:data/models/todo_model.dart';
import 'package:data/models/user_model.dart';
import 'package:domain/entities/goal_status.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Client get httpClient => Client();
  @preResolve
  Future<Box<UserModel>> get userBox => Hive.openBox<UserModel>('users');
  @preResolve
  Future<Box<TodoModel>> get todoBox => Hive.openBox<TodoModel>('todos');
  @preResolve
  Future<Box<TodoModel>> get deletedTodoBox => Hive.openBox<TodoModel>('deleted_todos');
  @preResolve
  Future<Box<GoalModel>> get goalBox => Hive.openBox<GoalModel>('goals');
  @preResolve
  Future<Box<GoalStatus>> get goalStatusBox => Hive.openBox<GoalStatus>('goalStatus');
  @lazySingleton
  FlutterSecureStorage get secureStorage => FlutterSecureStorage();
}