import 'package:data/injection/di.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:data/injection/di.dart' as data;
import 'package:domain/injection/di.dart' as domain;
import 'package:presentation/injection/di.dart' as presentation;

@InjectableInit()
Future<void> configureAllDependencies() async {
  final GetIt getIt = GetIt.instance;

  await data.configureDependencies(getIt: getIt);
  await domain.configureDependencies(getIt: getIt);
  await presentation.configureDependencies(getIt: getIt);
}
