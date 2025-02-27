// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toondo/data/models/goal.dart';
import 'package:toondo/data/models/user.dart';
import 'package:toondo/data/repositories/todo_repository.dart';
import 'package:toondo/services/gpt_service.dart';
import 'package:toondo/services/user_service.dart';
import 'package:toondo/viewmodels/auth/signup_viewmodel.dart';
import 'package:toondo/viewmodels/goal/goal_management_viewmodel.dart';
import 'package:toondo/viewmodels/goal/goal_viewmodel.dart';
import 'package:toondo/services/goal_service.dart';
import 'package:toondo/services/todo_service.dart';
import 'package:toondo/viewmodels/home_viewmodel.dart';
import 'package:toondo/viewmodels/todo/todo_viewmodel.dart';
import 'package:toondo/app/router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toondo/services/notification_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toondo/injection.dart'; // 주입 설정 가져오기
// import 'package:hive/hive.dart';?
import 'package:toondo/data/models/todo.dart';
import 'package:toondo/data/models/goal_status.dart'; // GoalStatus import

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive 초기화
  await Hive.initFlutter();

  // await Hive.deleteBoxFromDisk('todos');
  // await Hive.deleteBoxFromDisk('goals');
  // await Hive.deleteBoxFromDisk('user');

  // Hive 어댑터 등록
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(GoalStatusAdapter());
  Hive.registerAdapter(GoalAdapter()); // GoalAdapter 등록
  Hive.registerAdapter(UserAdapter()); // UserAdapter 등록 (typeId는 User 클래스와 일치해야 함)

  // 다른 모델의 어댑터도 여기에 등록 (예: GoalAdapter())
  // Hive.registerAdapter(GoalAdapter());

  // Hive 박스 열기
  final Box<Todo> todoBox = await Hive.openBox<Todo>('todos');
  final Box<Todo> deletedTodoBox = await Hive.openBox<Todo>('deleted_todos');
  final Box<Goal> goalBox = await Hive.openBox<Goal>('goals');
  final Box<User> userBox = await Hive.openBox<User>('user');

  // await todoBox.clear(); // 기존 데이터를 모두 삭제 (개발 중에만 사용)
  // await goalBox.clear(); // 기존 데이터를 모두 삭제 (개발 중에만 사용)
  // await userBox.clear(); // 기존 데이터를 모두 삭제 (개발 중에만 사용)

  // 다른 박스도 여기에 열기 (예: goals 박스)
  // final Box<Goal> goalBox = await Hive.openBox<Goal>('goals');

  // TodoService 인스턴스 생성
  final userService = UserService(userBox);
  final todoService = TodoService(todoBox, userService);
  final goalService = GoalService(goalBox, userService); // GoalService 인스턴스 생성
  final gptService = GptService(userService: userService);

  // GetIt 주입 설정 진행
  setupInjection();
  final todoRepository = getIt<TodoRepository>();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SignupViewModel>(
          create: (_) => SignupViewModel(),
        ),
        // Provider<TodoService> 등록
        Provider<TodoService>(
          create: (_) => todoService),
        // Provider<GoalService> 등록
        Provider<GoalService>(
          create: (_) => goalService),
        // Provider<UserService> 등록
        Provider<UserService>(
          create: (_) => userService),
        Provider<GptService>(
          create: (_) => gptService),
        Provider<TodoRepository>(
          create: (_) => todoRepository,
        ),
        // ChangeNotifierProvider for GoalViewModel
        ChangeNotifierProvider<GoalViewModel>(
          create: (context) => GoalViewModel(
            goalService: Provider.of<GoalService>(context, listen: false),
          )..loadGoals(),
        ),
        // ChangeNotifierProvider for TodoViewModel
        ChangeNotifierProvider<TodoViewModel>(
          create: (context) => TodoViewModel(
            Provider.of<TodoService>(context, listen: false),
          )..loadTodos(),
        ),
        ChangeNotifierProvider<HomeViewModel>(
          create: (context) => HomeViewModel(
            goalViewModel: Provider.of<GoalViewModel>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<GoalManagementViewModel>(
          create: (context) => GoalManagementViewModel(
            // 생성자에 GoalService or GoalViewModel 등 필요한 의존성 주입
            goalViewModel: Provider.of<GoalViewModel>(context, listen: false),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // StatefulWidget으로 변경하여 NotificationService를 초기화
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationService _notificationService = NotificationService();

  // NavigatorKey를 사용하여 어디서나 Navigator에 접근 가능하게 함
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Delay the notification initialization until after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestPermissionsAndInitializeNotifications();
    });
  }

  // 알림 권한 요청 및 알림 서비스 초기화
  Future<void> _requestPermissionsAndInitializeNotifications() async {
    // 알림 권한 요청
    PermissionStatus status = await Permission.notification.status;

    if (status.isDenied || status.isRestricted) {
      // 권한 요청
      status = await Permission.notification.request();
    }

    if (status.isGranted) {
      // 권한이 부여된 경우 알림 서비스 초기화 및 알림 예약
      if (navigatorKey.currentContext != null) {
        await _notificationService.initialize(navigatorKey.currentContext!);
        await _notificationService.scheduleAllNotifications();
      } else {
        print("Navigator context is null, cannot initialize notifications.");
      }
    } else if (status.isPermanentlyDenied) {
      // 사용자가 권한을 영구적으로 거부한 경우 설정으로 유도
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
    return MaterialApp(
      title: 'Todolist with Alarm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey, // navigatorKey 설정
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}