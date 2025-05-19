// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:domain/entities/goal.dart' as _i876;
import 'package:domain/entities/todo.dart' as _i429;
import 'package:domain/usecases/auth/check_phone_number_exists.dart' as _i426;
import 'package:domain/usecases/auth/get_token.dart' as _i415;
import 'package:domain/usecases/auth/login.dart' as _i1068;
import 'package:domain/usecases/auth/logout.dart' as _i969;
import 'package:domain/usecases/auth/register.dart' as _i899;
import 'package:domain/usecases/character/slime_on_gesture.dart' as _i610;
import 'package:domain/usecases/character/slime_on_massage.dart' as _i642;
import 'package:domain/usecases/goal/create_goal_remote.dart' as _i343;
import 'package:domain/usecases/goal/delete_goal_local.dart' as _i563;
import 'package:domain/usecases/goal/delete_goal_remote.dart' as _i397;
import 'package:domain/usecases/goal/get_completed_goals.dart' as _i368;
import 'package:domain/usecases/goal/get_givenup_goals.dart' as _i292;
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
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:presentation/viewmodels/character/chat_viewmodel.dart' as _i178;
import 'package:presentation/viewmodels/character/slime_character_vm.dart'
    as _i88;
import 'package:presentation/viewmodels/global/app_notification_viewmodel.dart'
    as _i370;
import 'package:presentation/viewmodels/global/app_theme_viewmodel.dart'
    as _i1040;
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart'
    as _i742;
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart'
    as _i940;
import 'package:presentation/viewmodels/home/home_viewmodel.dart' as _i370;
import 'package:presentation/viewmodels/login/login_viewmodel.dart' as _i764;
import 'package:presentation/viewmodels/my_page/display_setting/display_setting_viewmodel.dart'
    as _i81;
import 'package:presentation/viewmodels/my_page/my_page_viewmodel.dart'
    as _i272;
import 'package:presentation/viewmodels/my_page/notification_setting/notification_setting_viewmodel.dart'
    as _i942;
import 'package:presentation/viewmodels/my_page/notification_setting/time_picker_viewmodel.dart'
    as _i393;
import 'package:presentation/viewmodels/onboarding/onboarding_viewmodel.dart'
    as _i657;
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart' as _i705;
import 'package:presentation/viewmodels/todo/todo_input_viewmodel.dart' as _i72;
import 'package:presentation/viewmodels/todo/todo_manage_viewmodel.dart'
    as _i506;
import 'package:presentation/viewmodels/welcome/welcome_viewmodel.dart'
    as _i197;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i81.DisplaySettingViewModel>(
      () => _i81.DisplaySettingViewModel(),
    );
    gh.lazySingleton<_i197.WelcomeViewModel>(
      () => _i197.WelcomeViewModel(
        getTokenUseCase: gh<_i415.GetTokenUseCase>(),
        logoutUseCase: gh<_i969.LogoutUseCase>(),
      ),
    );
    gh.lazySingleton<_i940.GoalManagementViewModel>(
      () => _i940.GoalManagementViewModel(
        getGoalsLocalUseCase: gh<_i477.GetGoalsLocalUseCase>(),
        getGoalsRemoteUseCase: gh<_i371.GetGoalsRemoteUseCase>(),
        updateGoalRemoteUseCase: gh<_i200.UpdateGoalRemoteUseCase>(),
        updateGoalLocalUseCase: gh<_i1031.UpdateGoalLocalUseCase>(),
        deleteGoalRemoteUseCase: gh<_i397.DeleteGoalRemoteUseCase>(),
        deleteGoalLocalUseCase: gh<_i563.DeleteGoalLocalUseCase>(),
        getInProgressGoalsUseCase: gh<_i243.GetInProgressGoalsUseCase>(),
        getCompletedGoalsUseCase: gh<_i368.GetCompletedGoalsUseCase>(),
        getGivenUpGoalsUseCase: gh<_i292.GetGivenUpGoalsUseCase>(),
        updateGoalStatusUseCase: gh<_i856.UpdateGoalStatusUseCase>(),
        updateGoalProgressUseCase: gh<_i739.UpdateGoalProgressUseCase>(),
      ),
    );
    gh.lazySingleton<_i764.LoginViewModel>(
      () => _i764.LoginViewModel(loginUseCase: gh<_i1068.LoginUseCase>()),
    );
    gh.factory<_i272.MyPageViewModel>(
      () => _i272.MyPageViewModel(
        getUserUseCase: gh<_i991.GetUserUseCase>(),
        commitTodosUseCase: gh<_i412.CommitTodosUseCase>(),
        fetchTodosUseCase: gh<_i314.FetchTodosUseCase>(),
      ),
    );
    gh.lazySingleton<_i72.TodoInputViewModel>(
      () => _i72.TodoInputViewModel(
        todo: gh<_i429.Todo>(),
        isDDayTodo: gh<bool>(),
        createTodoUseCase: gh<_i834.CreateTodoUseCase>(),
        updateTodoUseCase: gh<_i375.UpdateTodoUseCase>(),
        getGoalsLocalUseCase: gh<_i477.GetGoalsLocalUseCase>(),
      ),
    );
    gh.factory<_i178.ChatViewModel>(
      () => _i178.ChatViewModel(gh<_i642.SlimeOnMessageUseCase>()),
    );
    gh.lazySingleton<_i506.TodoManageViewModel>(
      () => _i506.TodoManageViewModel(
        fetchTodosUseCase: gh<_i314.FetchTodosUseCase>(),
        deleteTodoUseCase: gh<_i552.DeleteTodoUseCase>(),
        getTodosUseCase: gh<_i362.GetAllTodosUseCase>(),
        updateTodoStatusUseCase: gh<_i183.UpdateTodoStatusUseCase>(),
        updateTodoDatesUseCase: gh<_i182.UpdateTodoDatesUseCase>(),
        getGoalsLocalUseCase: gh<_i477.GetGoalsLocalUseCase>(),
        initialDate: gh<DateTime>(),
      ),
    );
    gh.lazySingleton<_i370.AppNotificationViewModel>(
      () => _i370.AppNotificationViewModel(
        gh<_i22.GetNotificationSettingsUseCase>(),
        gh<_i930.SetNotificationSettingsUseCase>(),
      ),
    );
    gh.factory<_i393.TimePickerViewModel>(
      () => _i393.TimePickerViewModel(gh<_i236.SetReminderTime>()),
    );
    gh.lazySingleton<_i742.GoalInputViewModel>(
      () => _i742.GoalInputViewModel(
        createGoalRemoteUseCase: gh<_i343.CreateGoalRemoteUseCase>(),
        saveGoalLocalUseCase: gh<_i881.SaveGoalLocalUseCase>(),
        updateGoalRemoteUseCase: gh<_i200.UpdateGoalRemoteUseCase>(),
        updateGoalLocalUseCase: gh<_i1031.UpdateGoalLocalUseCase>(),
        targetGoal: gh<_i876.Goal>(),
      ),
    );
    gh.factory<_i942.NotificationSettingViewModel>(
      () => _i942.NotificationSettingViewModel(
        gh<_i370.AppNotificationViewModel>(),
      ),
    );
    gh.lazySingleton<_i705.SignupViewModel>(
      () => _i705.SignupViewModel(
        registerUserUseCase: gh<_i899.RegisterUseCase>(),
        sendSmsCodeUseCase: gh<_i461.SendSmsCode>(),
        verifySmsCodeUseCase: gh<_i73.VerifySmsCode>(),
        checkPhoneNumberExistsUseCase:
            gh<_i426.CheckPhoneNumberExistsUseCase>(),
      ),
    );
    gh.factory<_i88.SlimeCharacterViewModel>(
      () => _i88.SlimeCharacterViewModel(gh<_i610.SlimeOnGestureUseCase>()),
    );
    gh.lazySingleton<_i370.HomeViewModel>(
      () => _i370.HomeViewModel(
        gh<_i243.GetInProgressGoalsUseCase>(),
        gh<_i849.GetUserNicknameUseCase>(),
      ),
    );
    gh.lazySingleton<_i1040.AppThemeViewModel>(
      () => _i1040.AppThemeViewModel(
        gh<_i129.GetThemeModeUseCase>(),
        gh<_i366.SetThemeModeUseCase>(),
      ),
    );
    gh.lazySingleton<_i657.OnboardingViewModel>(
      () => _i657.OnboardingViewModel(
        updateNickNameUseCase: gh<_i910.UpdateNickNameUseCase>(),
      ),
    );
    return this;
  }
}
