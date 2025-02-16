import 'package:presentation/injection/di.dart' as presentation;
import 'package:domain/injection/di.dart' as domain;
import 'package:data/injection/di.dart' as data;
import 'package:get_it/get_it.dart';

void configureAllDependencies() {
  final GetIt getIt = GetIt.instance;
  
  presentation.configureDependencies(getIt: getIt);
  domain.configureDependencies(getIt: getIt);
  data.configureDependencies(getIt: getIt);
}