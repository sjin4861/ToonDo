import 'package:domain/entities/theme_mode_type.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/character/chat_viewmodel.dart';
import 'package:presentation/viewmodels/onboarding/onboarding_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:presentation/navigation/router.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';
import 'package:presentation/viewmodels/global/app_theme_viewmodel.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';
import 'package:data/models/todo_model.dart';
import 'package:data/models/user_model.dart';
import 'package:data/models/goal_model.dart';
import 'package:data/models/goal_status_enum.dart';
import 'package:toondo/injection/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Hive 어댑터 등록
  Hive.registerAdapter(TodoModelAdapter());
  Hive.registerAdapter(GoalModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(GoalStatusEnumAdapter());

  // Hive 박스 열기
  await Hive.openBox<TodoModel>('todos');
  await Hive.openBox<TodoModel>('deleted_todos');
  await Hive.openBox<GoalModel>('goals');
  await Hive.openBox<UserModel>('user');

  // 의존성 주입
  await configureAllDependencies();

  // 테마 공통 관리
  final themeVM = GetIt.instance<AppThemeViewModel>();
  await themeVM.load();
  print('Current theme mode: ${themeVM.mode}');

  runApp(MyApp(themeVM: themeVM));
}

class MyApp extends StatefulWidget {
  final AppThemeViewModel themeVM;

  const MyApp({super.key, required this.themeVM});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    widget.themeVM.addListener(() {
      print('[MyAppState] themeVM changed, calling setState()'); // ✅ 추가
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Permission.notification.status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => widget.themeVM),
        ChangeNotifierProvider(
            create: (_) => GetIt.instance<SignupViewModel>()),
        ChangeNotifierProvider(
            create: (_) => GetIt.instance<GoalManagementViewModel>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<HomeViewModel>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<ChatViewModel>()),
        ChangeNotifierProvider(
            create: (_) => GetIt.instance<OnboardingViewModel>()),
      ],
      child: Consumer<AppThemeViewModel>(
        builder: (context, vm, _) {
          return MaterialApp(
            themeMode: vm.mode.toFlutterMode(),
            navigatorKey: navigatorKey,
            initialRoute: '/',
            onGenerateRoute: AppRouter.generateRoute,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
          );
        },
      ),
    );
  }
}
