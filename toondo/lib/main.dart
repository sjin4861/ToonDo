import 'package:domain/entities/theme_mode_type.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/global/app_notification_viewmodel.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  await initializeDateFormatting('ko_KR', '');

  // 테마 공통 관리
  final themeVM = GetIt.instance<AppThemeViewModel>();
  await themeVM.load();

  // 알림 공통 관리
  final notificationVM = GetIt.instance<AppNotificationViewModel>();
  await notificationVM.load();

  runApp(MyApp(themeVM: themeVM, notificationVM: notificationVM));
}

class MyApp extends StatefulWidget {
  final AppThemeViewModel themeVM;
  final AppNotificationViewModel notificationVM;

  const MyApp({super.key, required this.themeVM, required this.notificationVM});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    widget.themeVM.addListener(() {
      setState(() {});
    });

    widget.notificationVM.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Permission.notification.status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => widget.themeVM),
              ChangeNotifierProvider(create: (_) => widget.notificationVM),
              ChangeNotifierProvider(
                  create: (_) => GetIt.instance<SignupViewModel>()),
              ChangeNotifierProvider(
                  create: (_) => GetIt.instance<GoalManagementViewModel>()),
              ChangeNotifierProvider(
                  create: (_) => GetIt.instance<HomeViewModel>()),
              ChangeNotifierProvider(
                  create: (_) => GetIt.instance<OnboardingViewModel>()),
            ],
            child: Consumer<AppThemeViewModel>(
              builder: (context, vm, _) {
                return MaterialApp(
                  locale: const Locale('ko', 'KR'),
                  supportedLocales: const [
                    Locale('ko', 'KR'),
                    Locale('en', 'US'),
                  ],
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  themeMode: vm.mode.toFlutterMode(),
                  theme: ThemeData.light().copyWith(
                    scaffoldBackgroundColor: const Color(
                        0xFFFDFDFD), // 라이트 모드 배경색
                  ),
                  navigatorKey: navigatorKey,
                  initialRoute: '/',
                  onGenerateRoute: AppRouter.generateRoute,
                  darkTheme: ThemeData.dark(),
                );
              },
            ),
          );
        },
    );
  }
}
