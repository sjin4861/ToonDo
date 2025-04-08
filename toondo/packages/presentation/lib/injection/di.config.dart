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
import 'package:domain/entities/user.dart' as _i30;
import 'package:domain/usecases/auth/check_phone_number_exists.dart' as _i426;
import 'package:domain/usecases/auth/get_token.dart' as _i415;
import 'package:domain/usecases/auth/login.dart' as _i1068;
import 'package:domain/usecases/auth/register.dart' as _i899;
import 'package:domain/usecases/goal/create_goal.dart' as _i695;
import 'package:domain/usecases/goal/delete_goal.dart' as _i582;
import 'package:domain/usecases/goal/get_completed_goals.dart' as _i368;
import 'package:domain/usecases/goal/get_givenup_goals.dart' as _i292;
import 'package:domain/usecases/goal/get_goals.dart' as _i737;
import 'package:domain/usecases/goal/get_inprogress_goals.dart' as _i243;
import 'package:domain/usecases/goal/read_goals.dart' as _i663;
import 'package:domain/usecases/goal/update_goal.dart' as _i422;
import 'package:domain/usecases/goal/update_goal_progress.dart' as _i739;
import 'package:domain/usecases/goal/update_goal_status.dart' as _i856;
import 'package:domain/usecases/gpt/get_slime_response.dart' as _i88;
import 'package:domain/usecases/sms/send_sms_code.dart' as _i461;
import 'package:domain/usecases/sms/verify_sms_code.dart' as _i73;
import 'package:domain/usecases/todo/commit_todos.dart' as _i412;
import 'package:domain/usecases/todo/create_todo.dart' as _i834;
import 'package:domain/usecases/todo/delete_todo.dart' as _i552;
import 'package:domain/usecases/todo/fetch_todos.dart' as _i314;
import 'package:domain/usecases/todo/get_all_todos.dart' as _i362;
import 'package:domain/usecases/todo/update_todo.dart' as _i375;
import 'package:domain/usecases/todo/update_todo_dates.dart' as _i182;
import 'package:domain/usecases/todo/update_todo_status.dart' as _i183;
import 'package:domain/usecases/user/get_user_nickname.dart' as _i849;
import 'package:domain/usecases/user/update_nickname.dart' as _i910;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:presentation/viewmodels/character/slime_character_viewmodel.dart'
    as _i865;
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart'
    as _i742;
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart'
    as _i940;
import 'package:presentation/viewmodels/goal/goal_viewmodel.dart' as _i194;
import 'package:presentation/viewmodels/home/home_viewmodel.dart' as _i370;
import 'package:presentation/viewmodels/login/login_viewmodel.dart' as _i764;
import 'package:presentation/viewmodels/my_page/my_page_viewmodel.dart'
    as _i272;
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
    gh.lazySingleton<_i865.SlimeCharacterViewModel>(
      () => _i865.SlimeCharacterViewModel(),
    );
    gh.lazySingleton<_i393.TimePickerViewModel>(
      () => _i393.TimePickerViewModel(),
    );
    gh.lazySingleton<_i742.GoalInputViewModel>(
      () => _i742.GoalInputViewModel(
        createGoalUseCase: gh<_i695.CreateGoalUseCase>(),
        updateGoalUseCase: gh<_i422.UpdateGoalUseCase>(),
        targetGoal: gh<_i876.Goal>(),
      ),
    );
    gh.lazySingleton<_i764.LoginViewModel>(
      () => _i764.LoginViewModel(loginUseCase: gh<_i1068.LoginUseCase>()),
    );
    gh.lazySingleton<_i272.MyPageViewModel>(
      () => _i272.MyPageViewModel(
        currentUser: gh<_i30.User>(),
        commitTodosUseCase: gh<_i412.CommitTodosUseCase>(),
        fetchTodosUseCase: gh<_i314.FetchTodosUseCase>(),
      ),
    );
    gh.lazySingleton<_i370.HomeViewModel>(
      () => _i370.HomeViewModel(
        getInProgressGoalsUseCase: gh<_i243.GetInProgressGoalsUseCase>(),
        deleteGoalUseCase: gh<_i582.DeleteGoalUseCase>(),
        getUserNicknameUseCase: gh<_i849.GetUserNicknameUseCase>(),
        getSlimeResponseUseCase: gh<_i88.GetSlimeResponseUseCase>(),
      ),
    );
    gh.lazySingleton<_i72.TodoInputViewModel>(
      () => _i72.TodoInputViewModel(
        todo: gh<_i429.Todo>(),
        isDDayTodo: gh<bool>(),
        createTodoUseCase: gh<_i834.CreateTodoUseCase>(),
        updateTodoUseCase: gh<_i375.UpdateTodoUseCase>(),
        getGoalsUseCase: gh<_i737.GetGoalsUseCase>(),
      ),
    );
    gh.lazySingleton<_i940.GoalManagementViewModel>(
      () => _i940.GoalManagementViewModel(
        readGoalsUseCase: gh<_i663.ReadGoalsUseCase>(),
        updateGoalUseCase: gh<_i422.UpdateGoalUseCase>(),
        deleteGoalUseCase: gh<_i582.DeleteGoalUseCase>(),
        getInProgressGoalsUseCase: gh<_i243.GetInProgressGoalsUseCase>(),
        getGivenUpGoalsUseCase: gh<_i292.GetGivenUpGoalsUseCase>(),
        getCompletedGoalsUseCase: gh<_i368.GetCompletedGoalsUseCase>(),
        updateGoalProgressUseCase: gh<_i739.UpdateGoalProgressUseCase>(),
        updateGoalStatusUseCase: gh<_i856.UpdateGoalStatusUseCase>(),
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
    gh.lazySingleton<_i197.WelcomeViewModel>(
      () =>
          _i197.WelcomeViewModel(getTokenUseCase: gh<_i415.GetTokenUseCase>()),
    );
    gh.lazySingleton<_i506.TodoManageViewModel>(
      () => _i506.TodoManageViewModel(
        fetchTodosUseCase: gh<_i314.FetchTodosUseCase>(),
        deleteTodoUseCase: gh<_i552.DeleteTodoUseCase>(),
        commitTodosUseCase: gh<_i412.CommitTodosUseCase>(),
        createTodoUseCase: gh<_i834.CreateTodoUseCase>(),
        getTodosUseCase: gh<_i362.GetAllTodosUseCase>(),
        updateTodoStatusUseCase: gh<_i183.UpdateTodoStatusUseCase>(),
        updateTodoDatesUseCase: gh<_i182.UpdateTodoDatesUseCase>(),
        readGoalUseCase: gh<_i663.ReadGoalsUseCase>(),
        initialDate: gh<DateTime>(),
      ),
    );
    gh.lazySingleton<_i194.GoalViewModel>(
      () => _i194.GoalViewModel(
        fetchGoalsUseCase: gh<_i663.ReadGoalsUseCase>(),
        createGoalUseCase: gh<_i695.CreateGoalUseCase>(),
        updateGoalUseCase: gh<_i422.UpdateGoalUseCase>(),
        deleteGoalUseCase: gh<_i582.DeleteGoalUseCase>(),
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
