import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:data/injection/di.config.dart';
import 'package:data/repositories/auth_repository_impl.dart';

@InjectableInit()
void configureDependencies({required GetIt getIt}) => getIt.init();
