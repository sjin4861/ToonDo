import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'injection/di.dart'; // DI 설정 (lib/injection/di.dart)
import 'package:get_it/get_it.dart'; // Add this import
import 'package:injectable/injectable.dart'; // Add this import
import 'package:presentation/navigation/router.dart'; // 네비게이션 라우터
// Hive 어댑터 (데이터 모델) 등록을 위한 임포트
import 'package:data/models/todo_model.dart';
import 'package:data/models/goal_model.dart';
import 'package:data/models/user_model.dart';
import 'package:data/models/goal_status.dart';
// Provider로 주입할 ViewModel들
import 'package:presentation/viewmodels/auth/signup_viewmodel.dart';
import 'package:presentation/viewmodels/goal/goal_viewmodel.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';
import 'package:presentation/viewmodels/todo/todo_viewmodel.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';
// NotificationService는 DI로 관리 (위 di.dart에서 등록)

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive 초기화
  await Hive.initFlutter();

  // 의존성 주입 설정 (GetIt 및 Injectable)
  configureAllDependencies();

  // Hive 어댑터 등록
  Hive.registerAdapter(TodoModelAdapter());
  Hive.registerAdapter(GoalStatusAdapter());
  Hive.registerAdapter(GoalModelAdapter());
  Hive.registerAdapter(UserModelAdapter());

  // Hive 박스 열기
  await Hive.openBox<TodoModel>('todos');
  await Hive.openBox<TodoModel>('deleted_todos');
  await Hive.openBox<GoalModel>('goals');
  await Hive.openBox<UserModel>('user');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 어디서든 Navigator에 접근할 수 있도록 전역 NavigatorKey 설정
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // 첫 프레임 렌더링 후 알림 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNotifications();
    });
  }

  Future<void> _initializeNotifications() async {
    // 알림 권한 상태 확인
    PermissionStatus status = await Permission.notification.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.notification.request();
    }
    if (status.isGranted) {
      if (navigatorKey.currentContext != null) {
        await getIt<NotificationService>()
            .initialize(navigatorKey.currentContext!);
        await getIt<NotificationService>().scheduleAllNotifications();
      } else {
        print("Navigator context is null, cannot initialize notifications.");
      }
    } else if (status.isPermanentlyDenied) {
      bool opened = await openAppSettings();
      if (!opened) {
        print("설정 앱을 열 수 없습니다.");
      }
    } else {
      print("알림 권한이 거부되었습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 각 ViewModel은 DI에서 주입받음 (GetIt)
        ChangeNotifierProvider<SignupViewModel>(
          create: (_) => getIt<SignupViewModel>(),
        ),
        ChangeNotifierProvider<GoalViewModel>(
          create: (_) => getIt<GoalViewModel>()..loadGoals(),
        ),
        ChangeNotifierProvider<TodoViewModel>(
          create: (_) => getIt<TodoViewModel>()..loadTodos(),
        ),
        ChangeNotifierProvider<HomeViewModel>(
          create: (_) => getIt<HomeViewModel>(),
        ),
        ChangeNotifierProvider<GoalManagementViewModel>(
          create: (_) => getIt<GoalManagementViewModel>(),
        ),
      ],
      child: MaterialApp(
        title: 'Todolist with Alarm',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorKey: navigatorKey,
        initialRoute: '/',
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
