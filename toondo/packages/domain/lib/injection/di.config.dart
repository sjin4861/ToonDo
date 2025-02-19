// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:domain/repositories/auth_repository.dart' as _i427;
import 'package:domain/repositories/goal_repository.dart' as _i559;
import 'package:domain/repositories/sms_repository.dart' as _i366;
import 'package:domain/repositories/todo_repository.dart' as _i158;
import 'package:domain/repositories/user_repository.dart' as _i988;
import 'package:domain/usecases/auth/get_token.dart' as _i415;
import 'package:domain/usecases/auth/login.dart' as _i1068;
import 'package:domain/usecases/auth/logout.dart' as _i969;
import 'package:domain/usecases/auth/register.dart' as _i899;
import 'package:domain/usecases/goal/create_goal.dart' as _i695;
import 'package:domain/usecases/goal/delete_goal.dart' as _i582;
import 'package:domain/usecases/goal/get_goals.dart' as _i737;
import 'package:domain/usecases/goal/read_goals.dart' as _i663;
import 'package:domain/usecases/goal/update_goal.dart' as _i422;
import 'package:domain/usecases/sms/send_sms_code.dart' as _i461;
import 'package:domain/usecases/sms/verify_sms_code.dart' as _i73;
import 'package:domain/usecases/todo/add_todo.dart' as _i133;
import 'package:domain/usecases/todo/delete_todo.dart' as _i552;
import 'package:domain/usecases/todo/get_all_todos.dart' as _i362;
import 'package:domain/usecases/todo/update_todo_dates.dart' as _i182;
import 'package:domain/usecases/todo/update_todo_status.dart' as _i183;
import 'package:domain/usecases/user/get_user_nickname.dart' as _i849;
import 'package:domain/usecases/user/update_nickname.dart' as _i910;
import 'package:domain/usecases/user/update_points.dart' as _i1049;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i415.GetTokenUseCase>(
      () => _i415.GetTokenUseCase(gh<_i427.AuthRepository>()),
    );
    gh.factory<_i1068.LoginUseCase>(
      () => _i1068.LoginUseCase(gh<_i427.AuthRepository>()),
    );
    gh.factory<_i969.LogoutUseCase>(
      () => _i969.LogoutUseCase(gh<_i427.AuthRepository>()),
    );
    gh.factory<_i899.RegisterUseCase>(
      () => _i899.RegisterUseCase(gh<_i427.AuthRepository>()),
    );
    gh.factory<_i133.AddTodoUseCase>(
      () => _i133.AddTodoUseCase(gh<_i158.TodoRepository>()),
    );
    gh.factory<_i552.DeleteTodoUseCase>(
      () => _i552.DeleteTodoUseCase(gh<_i158.TodoRepository>()),
    );
    gh.factory<_i362.GetAllTodosUseCase>(
      () => _i362.GetAllTodosUseCase(gh<_i158.TodoRepository>()),
    );
    gh.factory<_i182.UpdateTodoDates>(
      () => _i182.UpdateTodoDates(gh<_i158.TodoRepository>()),
    );
    gh.factory<_i183.UpdateTodoStatus>(
      () => _i183.UpdateTodoStatus(gh<_i158.TodoRepository>()),
    );
    gh.factory<_i695.CreateGoal>(
      () => _i695.CreateGoal(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i582.DeleteGoal>(
      () => _i582.DeleteGoal(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i737.GetGoalsUseCase>(
      () => _i737.GetGoalsUseCase(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i663.ReadGoals>(
      () => _i663.ReadGoals(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i422.UpdateGoal>(
      () => _i422.UpdateGoal(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i461.SendSmsCode>(
      () => _i461.SendSmsCode(gh<_i366.SmsRepository>()),
    );
    gh.factory<_i73.VerifySmsCode>(
      () => _i73.VerifySmsCode(gh<_i366.SmsRepository>()),
    );
    gh.factory<_i849.GetUserNicknameUseCase>(
      () => _i849.GetUserNicknameUseCase(gh<_i988.UserRepository>()),
    );
    gh.factory<_i910.UpdateNickNameUseCase>(
      () => _i910.UpdateNickNameUseCase(gh<_i988.UserRepository>()),
    );
    gh.factory<_i1049.UpdateUserPointsUseCase>(
      () => _i1049.UpdateUserPointsUseCase(gh<_i988.UserRepository>()),
    );
    return this;
  }
}
