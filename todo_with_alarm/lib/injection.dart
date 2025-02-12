import 'package:get_it/get_it.dart';
import 'package:todo_with_alarm/data/datasources/local/todo_local_datasource.dart';
import 'package:todo_with_alarm/data/datasources/remote/todo_remote_datasource.dart';
import 'package:todo_with_alarm/data/repositories/todo_repository.dart';
import 'package:http/http.dart' as http;
import 'package:todo_with_alarm/services/auth_service.dart';

final GetIt getIt = GetIt.instance;

void setupInjection() {
  // 외부 의존성 등록
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<AuthService>(() => AuthService());

  // 데이터 소스 등록
  getIt.registerSingleton<TodoLocalDatasource>(TodoLocalDatasource());
  getIt.registerLazySingleton<TodoRemoteDataSource>(() => TodoRemoteDataSource());

  // 레포지토리 등록
  getIt.registerLazySingleton<TodoRepository>(
    () => TodoRepository(
      localDatasource: getIt<TodoLocalDatasource>(),
      remoteDatasource: getIt<TodoRemoteDataSource>(),
    ),
  );
}
