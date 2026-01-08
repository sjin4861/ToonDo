// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:data/datasources/local/animation_local_datasource.dart'
    as _i938;
import 'package:data/datasources/local/auth_local_datasource.dart' as _i116;
import 'package:data/datasources/local/custom_icon_local_datasource.dart'
    as _i547;
import 'package:data/datasources/local/goal_local_datasource.dart' as _i34;
import 'package:data/datasources/local/secure_local_datasource.dart' as _i361;
import 'package:data/datasources/local/todo_local_datasource.dart' as _i91;
import 'package:data/datasources/local/user_local_datasource.dart' as _i1024;
import 'package:data/datasources/remote/auth_remote_datasource.dart' as _i954;
import 'package:data/datasources/remote/goal_remote_datasource.dart' as _i417;
import 'package:data/datasources/remote/todo_remote_datasource.dart' as _i627;
import 'package:data/datasources/remote/user_remote_datasource.dart' as _i813;
import 'package:data/injection/di_module.dart' as _i1048;
import 'package:data/models/custom_icon_model.dart' as _i27;
import 'package:data/models/goal_model.dart' as _i798;
import 'package:data/models/goal_status_enum.dart' as _i934;
import 'package:data/models/todo_model.dart' as _i923;
import 'package:data/models/user_model.dart' as _i245;
import 'package:data/repositories/auth_repository_impl.dart' as _i819;
import 'package:data/repositories/custom_icon_repository_impl.dart' as _i658;
import 'package:data/repositories/goal_repository_impl.dart' as _i527;
import 'package:data/repositories/notification_repository_impl.dart' as _i15;
import 'package:data/repositories/slime_repository_impl.dart' as _i366;
import 'package:data/repositories/theme_repository_impl.dart' as _i525;
import 'package:data/repositories/todo_repository_impl.dart' as _i366;
import 'package:data/repositories/user_repository_impl.dart' as _i537;
import 'package:data/utils/gesture_mapper.dart' as _i587;
import 'package:dio/dio.dart' as _i361;
import 'package:domain/repositories/auth_repository.dart' as _i427;
import 'package:domain/repositories/custom_icon_repository.dart' as _i447;
import 'package:domain/repositories/goal_repository.dart' as _i559;
import 'package:domain/repositories/notification_repository.dart' as _i267;
import 'package:domain/repositories/slime_repository.dart' as _i657;
import 'package:domain/repositories/theme_repository.dart' as _i578;
import 'package:domain/repositories/todo_repository.dart' as _i158;
import 'package:domain/repositories/user_repository.dart' as _i988;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i979.Box<_i245.UserModel>>(
      () => registerModule.userBox,
      preResolve: true,
    );
    await gh.factoryAsync<_i979.Box<_i798.GoalModel>>(
      () => registerModule.goalBox,
      preResolve: true,
    );
    await gh.factoryAsync<_i979.Box<_i934.GoalStatusEnum>>(
      () => registerModule.goalStatusBox,
      preResolve: true,
    );
    await gh.factoryAsync<_i979.Box<_i27.CustomIconModel>>(
      () => registerModule.customIconBox,
      preResolve: true,
    );
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i938.AnimationLocalDataSource>(
        () => _i938.AnimationLocalDataSource());
    gh.lazySingleton<_i519.Client>(() => registerModule.httpClient);
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i587.GestureMapper>(() => registerModule.gestureMapper);
    await gh.factoryAsync<_i979.Box<_i923.TodoModel>>(
      () => registerModule.deletedTodoBox,
      instanceName: 'deletedTodoBox',
      preResolve: true,
    );
    gh.lazySingleton<_i267.NotificationSettingRepository>(() =>
        _i15.NotificationSettingRepositoryImpl(gh<_i460.SharedPreferences>()));
    await gh.factoryAsync<_i979.Box<_i923.TodoModel>>(
      () => registerModule.todoBox,
      instanceName: 'todoBox',
      preResolve: true,
    );
    gh.lazySingleton<_i657.SlimeRepository>(() => _i366.SlimeRepositoryImpl());
    gh.lazySingleton<_i954.AuthRemoteDataSource>(
        () => _i954.AuthRemoteDataSource(gh<_i361.Dio>()));
    gh.lazySingleton<_i1024.UserLocalDatasource>(
        () => _i1024.UserLocalDatasource(gh<_i979.Box<_i245.UserModel>>()));
    gh.lazySingleton<_i116.AuthLocalDataSource>(
        () => _i116.AuthLocalDataSource(gh<_i979.Box<_i245.UserModel>>()));
    gh.lazySingleton<_i578.ThemeRepository>(
        () => _i525.ThemeRepositoryImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i361.SecureLocalDataSource>(
        () => _i361.SecureLocalDataSource(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i91.TodoLocalDatasource>(() => _i91.TodoLocalDatasource(
          gh<_i979.Box<_i923.TodoModel>>(instanceName: 'todoBox'),
          gh<_i979.Box<_i923.TodoModel>>(instanceName: 'deletedTodoBox'),
        ));
    gh.lazySingleton<_i34.GoalLocalDatasource>(() => _i34.GoalLocalDatasource(
          gh<_i979.Box<_i798.GoalModel>>(),
          gh<_i979.Box<_i934.GoalStatusEnum>>(),
        ));
    gh.lazySingleton<_i547.CustomIconLocalDatasource>(() =>
        _i547.CustomIconLocalDatasource(gh<_i979.Box<_i27.CustomIconModel>>()));
    gh.lazySingleton<_i447.CustomIconRepository>(() =>
        _i658.CustomIconRepositoryImpl(gh<_i547.CustomIconLocalDatasource>()));
    gh.lazySingleton<_i427.AuthRepository>(() => _i819.AuthRepositoryImpl(
          gh<_i954.AuthRemoteDataSource>(),
          gh<_i116.AuthLocalDataSource>(),
          gh<_i361.SecureLocalDataSource>(),
        ));
    gh.lazySingleton<_i627.TodoRemoteDataSource>(
        () => _i627.TodoRemoteDataSource(
              gh<_i361.Dio>(),
              gh<_i427.AuthRepository>(),
            ));
    gh.lazySingleton<_i417.GoalRemoteDataSource>(
        () => _i417.GoalRemoteDataSource(
              gh<_i361.Dio>(),
              gh<_i427.AuthRepository>(),
            ));
    gh.lazySingleton<_i813.UserRemoteDatasource>(
        () => _i813.UserRemoteDatasource(
              gh<_i361.Dio>(),
              gh<_i427.AuthRepository>(),
            ));
    gh.lazySingleton<_i559.GoalRepository>(() => _i527.GoalRepositoryImpl(
          localDatasource: gh<_i34.GoalLocalDatasource>(),
          remoteDatasource: gh<_i417.GoalRemoteDataSource>(),
        ));
    gh.lazySingleton<_i158.TodoRepository>(() => _i366.TodoRepositoryImpl(
          remoteDatasource: gh<_i627.TodoRemoteDataSource>(),
          localDatasource: gh<_i91.TodoLocalDatasource>(),
        ));
    gh.lazySingleton<_i988.UserRepository>(() => _i537.UserRepositoryImpl(
          remoteDatasource: gh<_i813.UserRemoteDatasource>(),
          localDatasource: gh<_i1024.UserLocalDatasource>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i1048.RegisterModule {}
