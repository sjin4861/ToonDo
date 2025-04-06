import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/character/slime_character_viewmodel.dart';
import 'package:presentation/viewmodels/onboarding/onboarding_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:presentation/navigation/router.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';
import 'package:presentation/viewmodels/goal/goal_viewmodel.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';
import 'package:data/models/todo_model.dart';
import 'package:data/models/user_model.dart';
import 'package:data/models/goal_model.dart';
import 'package:data/models/goal_status.dart';
import 'package:toondo/injection/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Hive 어댑터 등록
  Hive.registerAdapter(TodoModelAdapter());
  Hive.registerAdapter(GoalModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(GoalStatusAdapter());

  // Hive 박스 열기
  await Hive.openBox<TodoModel>('todos');
  await Hive.openBox<TodoModel>('deleted_todos');
  await Hive.openBox<GoalModel>('goals');
  await Hive.openBox<UserModel>('user');

  // 의존성 주입
  await configureAllDependencies();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // 알림 권한 확인 등 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final status = await Permission.notification.status;
      // 필요 시 권한 요청
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => GetIt.instance<SignupViewModel>()),
        ChangeNotifierProvider(
            create: (_) => GetIt.instance<GoalViewModel>()..loadGoals()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<HomeViewModel>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<SlimeCharacterViewModel>()),
        ChangeNotifierProvider(
            create: (_) => GetIt.instance<GoalManagementViewModel>()),
        ChangeNotifierProvider(
            create: (_) => GetIt.instance<OnboardingViewModel>()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        initialRoute: '/',
        onGenerateRoute: AppRouter.generateRoute,
        theme: ThemeData()
      ),
    );
  }
}
