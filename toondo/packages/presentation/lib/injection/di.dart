import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:presentation/injection/di.config.dart';

import 'package:domain/injection/di.dart' as domain_di;

@InjectableInit()
void configureDependencies({required GetIt getIt}) {
  final getIt = GetIt.instance;

  domain_di.configureDependencies(getIt: getIt);
  // presentation viewmodels도 이곳에서 설정
  getIt.init(); // presentation의 injectable init
}
