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
import 'package:data/datasources/remote/todo_remote_datasource.dart' as _i627;
import 'package:data/datasources/remote/user_remote_datasource.dart' as _i813;
import 'package:data/repositories/auth_repository_impl.dart' as _i819;
import 'package:data/repositories/character_repository_impl.dart' as _i919;
import 'package:data/repositories/goal_repository_impl.dart' as _i527;
import 'package:data/repositories/gpt_repository_impl.dart' as _i905;
import 'package:data/repositories/todo_repository_impl.dart' as _i366;
import 'package:data/repositories/user_repository_impl.dart' as _i537;
import 'package:domain/repositories/auth_repository.dart' as _i427;
import 'package:domain/repositories/character_repository.dart' as _i434;
import 'package:domain/repositories/goal_repository.dart' as _i559;
import 'package:domain/repositories/gpt_repository.dart' as _i183;
import 'package:domain/repositories/todo_repository.dart' as _i158;
import 'package:domain/repositories/user_repository.dart' as _i988;
import 'package:domain/usecases/user/get_user_nickname.dart' as _i849;
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i427.AuthRepository>(() => _i819.AuthRepositoryImpl(
          gh<_i954.AuthRemoteDataSource>(),
          gh<_i116.AuthLocalDataSource>(),
          gh<_i361.SecureLocalDataSource>(),
        ));
    gh.lazySingleton<_i434.CharacterRepository>(
        () => _i919.CharacterRepositoryImpl());
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
    gh.lazySingleton<_i183.GptRepository>(() => _i905.GptRepositoryImpl(
          gh<_i519.Client>(),
          gh<_i849.GetUserNicknameUseCase>(),
          gh<_i434.CharacterRepository>(),
        ));
    return this;
  }
}
