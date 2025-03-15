// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:data/datasources/local/auth_local_datasource.dart' as _i116;
import 'package:data/datasources/local/goal_local_datasource.dart' as _i34;
import 'package:data/datasources/local/secure_local_datasource.dart' as _i361;
import 'package:data/datasources/local/todo_local_datasource.dart' as _i91;
import 'package:data/datasources/local/user_local_datasource.dart' as _i1024;
import 'package:data/datasources/remote/auth_remote_datasource.dart' as _i954;
import 'package:data/datasources/remote/goal_remote_datasource.dart' as _i417;
import 'package:data/datasources/remote/sms_remote_datasource.dart' as _i268;
import 'package:data/datasources/remote/todo_remote_datasource.dart' as _i627;
import 'package:data/datasources/remote/user_remote_datasource.dart' as _i813;
import 'package:data/injection/di_module.dart' as _i1048;
import 'package:data/models/goal_model.dart' as _i798;
import 'package:data/models/todo_model.dart' as _i923;
import 'package:data/models/user_model.dart' as _i245;
import 'package:data/repositories/auth_repository_impl.dart' as _i819;
import 'package:data/repositories/character_repository_impl.dart' as _i919;
import 'package:data/repositories/goal_repository_impl.dart' as _i527;
import 'package:data/repositories/gpt_repository_impl.dart' as _i905;
import 'package:data/repositories/todo_repository_impl.dart' as _i366;
import 'package:data/repositories/user_repository_impl.dart' as _i537;
import 'package:domain/entities/goal_status.dart' as _i281;
import 'package:domain/repositories/auth_repository.dart' as _i427;
import 'package:domain/repositories/character_repository.dart' as _i434;
import 'package:domain/repositories/goal_repository.dart' as _i559;
import 'package:domain/repositories/gpt_repository.dart' as _i183;
import 'package:domain/repositories/todo_repository.dart' as _i158;
import 'package:domain/repositories/user_repository.dart' as _i988;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;

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
    await gh.factoryAsync<_i979.Box<_i281.GoalStatus>>(
      () => registerModule.goalStatusBox,
      preResolve: true,
    );
    gh.lazySingleton<_i519.Client>(() => registerModule.httpClient);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    await gh.factoryAsync<_i979.Box<_i923.TodoModel>>(
      () => registerModule.deletedTodoBox,
      instanceName: 'deletedTodoBox',
      preResolve: true,
    );
    gh.lazySingleton<_i954.AuthRemoteDataSource>(
        () => _i954.AuthRemoteDataSource(gh<_i519.Client>()));
    await gh.factoryAsync<_i979.Box<_i923.TodoModel>>(
      () => registerModule.todoBox,
      instanceName: 'todoBox',
      preResolve: true,
    );
    gh.lazySingleton<_i434.CharacterRepository>(
        () => _i919.CharacterRepositoryImpl());
    gh.lazySingleton<_i116.AuthLocalDataSource>(
        () => _i116.AuthLocalDataSource(gh<_i979.Box<_i245.UserModel>>()));
    gh.lazySingleton<_i1024.UserLocalDatasource>(
        () => _i1024.UserLocalDatasource(gh<_i979.Box<_i245.UserModel>>()));
    gh.lazySingleton<_i361.SecureLocalDataSource>(
        () => _i361.SecureLocalDataSource(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i91.TodoLocalDatasource>(() => _i91.TodoLocalDatasource(
          gh<_i979.Box<_i923.TodoModel>>(instanceName: 'todoBox'),
          gh<_i979.Box<_i923.TodoModel>>(instanceName: 'deletedTodoBox'),
        ));
    gh.lazySingleton<_i268.SmsRemoteDataSource>(
        () => _i268.SmsRemoteDataSource(client: gh<_i519.Client>()));
    gh.lazySingleton<_i34.GoalLocalDatasource>(() => _i34.GoalLocalDatasource(
          gh<_i979.Box<_i798.GoalModel>>(),
          gh<_i979.Box<_i281.GoalStatus>>(),
        ));
    gh.lazySingleton<_i427.AuthRepository>(() => _i819.AuthRepositoryImpl(
          gh<_i954.AuthRemoteDataSource>(),
          gh<_i116.AuthLocalDataSource>(),
          gh<_i361.SecureLocalDataSource>(),
        ));
    gh.lazySingleton<_i417.GoalRemoteDataSource>(
        () => _i417.GoalRemoteDataSource(
              gh<_i519.Client>(),
              gh<_i427.AuthRepository>(),
            ));
    gh.lazySingleton<_i627.TodoRemoteDataSource>(
        () => _i627.TodoRemoteDataSource(
              gh<_i519.Client>(),
              gh<_i427.AuthRepository>(),
            ));
    gh.lazySingleton<_i813.UserRemoteDatasource>(
        () => _i813.UserRemoteDatasource(
              gh<_i519.Client>(),
              gh<_i427.AuthRepository>(),
            ));
    gh.lazySingleton<_i158.TodoRepository>(() => _i366.TodoRepositoryImpl(
          remoteDatasource: gh<_i627.TodoRemoteDataSource>(),
          localDatasource: gh<_i91.TodoLocalDatasource>(),
        ));
    gh.lazySingleton<_i988.UserRepository>(() => _i537.UserRepositoryImpl(
          remoteDatasource: gh<_i813.UserRemoteDatasource>(),
          localDatasource: gh<_i1024.UserLocalDatasource>(),
        ));
    gh.lazySingleton<_i183.GptRepository>(() => _i905.GptRepositoryImpl(
          gh<_i519.Client>(),
          gh<_i988.UserRepository>(),
          gh<_i434.CharacterRepository>(),
        ));
    gh.lazySingleton<_i559.GoalRepository>(() => _i527.GoalRepositoryImpl(
          localDatasource: gh<_i34.GoalLocalDatasource>(),
          remoteDatasource: gh<_i417.GoalRemoteDataSource>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i1048.RegisterModule {}
