import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:data/injection/di.dart' as data;
import 'package:domain/injection/di.dart' as domain;
import 'package:presentation/injection/di.dart' as presentation;

@InjectableInit()
void configureAllDependencies() {
  final GetIt getIt = GetIt.instance;

  data.configureDependencies(getIt: getIt);
  domain.configureDependencies(getIt: getIt);
  presentation.configureDependencies(getIt: getIt);
}
