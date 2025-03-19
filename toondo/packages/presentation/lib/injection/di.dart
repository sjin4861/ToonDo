import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:presentation/injection/di.config.dart';


@InjectableInit()
Future<void> configureDependencies ({required GetIt getIt}) async => getIt.init();