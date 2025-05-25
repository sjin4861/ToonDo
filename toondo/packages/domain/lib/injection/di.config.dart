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
import 'package:domain/repositories/notification_repository.dart' as _i267;
import 'package:domain/repositories/slime_repository.dart' as _i657;
import 'package:domain/repositories/sms_repository.dart' as _i366;
import 'package:domain/repositories/theme_repository.dart' as _i578;
import 'package:domain/repositories/todo_repository.dart' as _i158;
import 'package:domain/repositories/user_repository.dart' as _i988;
import 'package:domain/usecases/auth/check_phone_number_exists.dart' as _i426;
import 'package:domain/usecases/auth/get_token.dart' as _i415;
import 'package:domain/usecases/auth/login.dart' as _i1068;
import 'package:domain/usecases/auth/logout.dart' as _i969;
import 'package:domain/usecases/auth/register.dart' as _i899;
import 'package:domain/usecases/character/slime_on_gesture.dart' as _i610;
import 'package:domain/usecases/character/slime_on_massage.dart' as _i642;
import 'package:domain/usecases/character/toggle_chat_mode.dart' as _i657;
import 'package:domain/usecases/goal/create_goal_remote.dart' as _i343;
import 'package:domain/usecases/goal/delete_goal_local.dart' as _i563;
import 'package:domain/usecases/goal/delete_goal_remote.dart' as _i397;
import 'package:domain/usecases/goal/get_completed_goals.dart' as _i368;
import 'package:domain/usecases/goal/get_givenup_goals.dart' as _i292;
import 'package:domain/usecases/goal/get_goal_by_id_from_local.dart' as _i901;
import 'package:domain/usecases/goal/get_goals_local.dart' as _i477;
import 'package:domain/usecases/goal/get_goals_remote.dart' as _i371;
import 'package:domain/usecases/goal/get_inprogress_goals.dart' as _i243;
import 'package:domain/usecases/goal/save_goal_local.dart' as _i881;
import 'package:domain/usecases/goal/update_goal_local.dart' as _i1031;
import 'package:domain/usecases/goal/update_goal_progress.dart' as _i739;
import 'package:domain/usecases/goal/update_goal_remote.dart' as _i200;
import 'package:domain/usecases/goal/update_goal_status.dart' as _i856;
import 'package:domain/usecases/notification/get_notification_settings.dart'
    as _i22;
import 'package:domain/usecases/notification/set_notification_settings.dart'
    as _i930;
import 'package:domain/usecases/notification/set_reminder_time.dart' as _i236;
import 'package:domain/usecases/sms/send_sms_code.dart' as _i461;
import 'package:domain/usecases/sms/verify_sms_code.dart' as _i73;
import 'package:domain/usecases/theme/get_theme_mode.dart' as _i129;
import 'package:domain/usecases/theme/set_theme_mode.dart' as _i366;
import 'package:domain/usecases/todo/add_todo.dart' as _i133;
import 'package:domain/usecases/todo/commit_todos.dart' as _i412;
import 'package:domain/usecases/todo/create_todo.dart' as _i834;
import 'package:domain/usecases/todo/delete_todo.dart' as _i552;
import 'package:domain/usecases/todo/fetch_todos.dart' as _i314;
import 'package:domain/usecases/todo/get_all_todos.dart' as _i362;
import 'package:domain/usecases/todo/update_todo.dart' as _i375;
import 'package:domain/usecases/todo/update_todo_dates.dart' as _i182;
import 'package:domain/usecases/todo/update_todo_status.dart' as _i183;
import 'package:domain/usecases/user/get_user.dart' as _i991;
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
    gh.lazySingleton<_i426.CheckPhoneNumberExistsUseCase>(
      () => _i426.CheckPhoneNumberExistsUseCase(gh<_i427.AuthRepository>()),
    );
    gh.factory<_i1068.LoginUseCase>(
      () => _i1068.LoginUseCase(gh<_i427.AuthRepository>()),
    );
    gh.factory<_i415.GetTokenUseCase>(
      () => _i415.GetTokenUseCase(gh<_i427.AuthRepository>()),
    );
    gh.factory<_i899.RegisterUseCase>(
      () => _i899.RegisterUseCase(gh<_i427.AuthRepository>()),
    );
    gh.factory<_i969.LogoutUseCase>(
      () => _i969.LogoutUseCase(gh<_i427.AuthRepository>()),
    );
    gh.factory<_i22.GetNotificationSettingsUseCase>(
      () => _i22.GetNotificationSettingsUseCase(
        gh<_i267.NotificationSettingRepository>(),
      ),
    );
    gh.factory<_i930.SetNotificationSettingsUseCase>(
      () => _i930.SetNotificationSettingsUseCase(
        gh<_i267.NotificationSettingRepository>(),
      ),
    );
    gh.factory<_i236.SetReminderTime>(
      () => _i236.SetReminderTime(gh<_i267.NotificationSettingRepository>()),
    );
    gh.factory<_i129.GetThemeModeUseCase>(
      () => _i129.GetThemeModeUseCase(gh<_i578.ThemeRepository>()),
    );
    gh.factory<_i366.SetThemeModeUseCase>(
      () => _i366.SetThemeModeUseCase(gh<_i578.ThemeRepository>()),
    );
    gh.factory<_i834.CreateTodoUseCase>(
      () => _i834.CreateTodoUseCase(gh<_i158.TodoRepository>()),
    );
    gh.factory<_i133.AddTodoUseCase>(
      () => _i133.AddTodoUseCase(gh<_i158.TodoRepository>()),
    );
    gh.factory<_i362.GetAllTodosUseCase>(
      () => _i362.GetAllTodosUseCase(gh<_i158.TodoRepository>()),
    );
    gh.factory<_i375.UpdateTodoUseCase>(
      () => _i375.UpdateTodoUseCase(gh<_i158.TodoRepository>()),
    );
    gh.factory<_i412.CommitTodosUseCase>(
      () => _i412.CommitTodosUseCase(gh<_i158.TodoRepository>()),
    );
    gh.factory<_i183.UpdateTodoStatusUseCase>(
      () => _i183.UpdateTodoStatusUseCase(gh<_i158.TodoRepository>()),
    );
    gh.factory<_i314.FetchTodosUseCase>(
      () => _i314.FetchTodosUseCase(gh<_i158.TodoRepository>()),
    );
    gh.factory<_i552.DeleteTodoUseCase>(
      () => _i552.DeleteTodoUseCase(gh<_i158.TodoRepository>()),
    );
    gh.factory<_i182.UpdateTodoDatesUseCase>(
      () => _i182.UpdateTodoDatesUseCase(gh<_i158.TodoRepository>()),
    );
    gh.factory<_i292.GetGivenUpGoalsUseCase>(
      () => _i292.GetGivenUpGoalsUseCase(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i397.DeleteGoalRemoteUseCase>(
      () => _i397.DeleteGoalRemoteUseCase(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i1031.UpdateGoalLocalUseCase>(
      () => _i1031.UpdateGoalLocalUseCase(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i371.GetGoalsRemoteUseCase>(
      () => _i371.GetGoalsRemoteUseCase(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i243.GetInProgressGoalsUseCase>(
      () => _i243.GetInProgressGoalsUseCase(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i563.DeleteGoalLocalUseCase>(
      () => _i563.DeleteGoalLocalUseCase(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i881.SaveGoalLocalUseCase>(
      () => _i881.SaveGoalLocalUseCase(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i477.GetGoalsLocalUseCase>(
      () => _i477.GetGoalsLocalUseCase(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i200.UpdateGoalRemoteUseCase>(
      () => _i200.UpdateGoalRemoteUseCase(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i343.CreateGoalRemoteUseCase>(
      () => _i343.CreateGoalRemoteUseCase(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i368.GetCompletedGoalsUseCase>(
      () => _i368.GetCompletedGoalsUseCase(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i856.UpdateGoalStatusUseCase>(
      () => _i856.UpdateGoalStatusUseCase(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i901.GetGoalByIdFromLocalUseCase>(
      () => _i901.GetGoalByIdFromLocalUseCase(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i739.UpdateGoalProgressUseCase>(
      () => _i739.UpdateGoalProgressUseCase(gh<_i559.GoalRepository>()),
    );
    gh.factory<_i73.VerifySmsCode>(
      () => _i73.VerifySmsCode(gh<_i366.SmsRepository>()),
    );
    gh.factory<_i461.SendSmsCode>(
      () => _i461.SendSmsCode(gh<_i366.SmsRepository>()),
    );
    gh.factory<_i1049.UpdateUserPointsUseCase>(
      () => _i1049.UpdateUserPointsUseCase(gh<_i988.UserRepository>()),
    );
    gh.factory<_i910.UpdateNickNameUseCase>(
      () => _i910.UpdateNickNameUseCase(gh<_i988.UserRepository>()),
    );
    gh.factory<_i991.GetUserUseCase>(
      () => _i991.GetUserUseCase(gh<_i988.UserRepository>()),
    );
    gh.factory<_i849.GetUserNicknameUseCase>(
      () => _i849.GetUserNicknameUseCase(gh<_i988.UserRepository>()),
    );
    gh.factory<_i642.SlimeOnMessageUseCase>(
      () => _i642.SlimeOnMessageUseCase(gh<_i657.SlimeRepository>()),
    );
    gh.factory<_i657.ToggleChatModeUseCase>(
      () => _i657.ToggleChatModeUseCase(gh<_i657.SlimeRepository>()),
    );
    gh.factory<_i610.SlimeOnGestureUseCase>(
      () => _i610.SlimeOnGestureUseCase(gh<_i657.SlimeRepository>()),
    );
    return this;
  }
}
