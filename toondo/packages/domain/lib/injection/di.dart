import 'package:domain/repositories/auth_repository.dart';
import 'package:domain/repositories/goal_repository.dart';
import 'package:domain/repositories/sms_repository.dart';
import 'package:domain/repositories/todo_repository.dart';
import 'package:domain/repositories/user_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/injection/di.config.dart';
import 'package:data/repositories/auth_repository_impl.dart';
import 'package:data/repositories/goal_repository_impl.dart';
import 'package:data/repositories/sms_repository_impl.dart';
import 'package:data/repositories/todo_repository_impl.dart';


@module
abstract class RepositoryModule {
  // Repository가 DI에 등록될 수 있도록 설정
  @singleton
  TodoRepository get todoRepository => TodoRepositoryImpl();
  
  @singleton
  SmsRepository get smsRepository => SmsRepositoryImpl();
  
  @singleton
  AuthRepository get authRepository => AuthRepositoryImpl();
  
  @singleton
  UserRepository get userRepository => UserRepositoryImpl();
  
  @singleton
  GoalRepository get goalRepository => GoalRepositoryImpl();
}

@module
abstract class UseCaseModule {
  // 특별한 초기화가 필요 없으면 여긴 안 적어도 됨
}
@InjectableInit()
void configureDependencies({required GetIt getIt}) => getIt.init();