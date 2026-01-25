import 'package:domain/entities/theme_mode_type.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
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
import 'package:data/models/custom_icon_model.dart';
import 'package:toondo/injection/di.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rive_common/rive_audio.dart';
import 'package:common/audio/audio_gate.dart';
import 'package:common/notification/reminder_notification_service.dart';

final ValueNotifier<bool> soundEnabled = ValueNotifier<bool>(true);
late AudioGate audioGate;

Future<void> _tryDeleteHiveLockFile(String boxName) async {
  try {
    // HiveFlutter 기본 저장 경로: <app-doc-dir>/hive
    final appDoc = await getApplicationDocumentsDirectory();
    final hiveDir = Directory(p.join(appDoc.path, 'hive'));
    final lockFile = File(p.join(hiveDir.path, '$boxName.lock'));
    if (await lockFile.exists()) {
      await lockFile.delete();
      debugPrint('[Hive] Deleted lock file: ${lockFile.path}');
    }
  } catch (e) {
    // best-effort
    debugPrint('[Hive] Failed to delete lock for $boxName: $e');
  }
}

Future<void> _openHiveBoxSafely<T>(String name) async {
  const timeout = Duration(seconds: 5);
  if (Hive.isBoxOpen(name)) return;
  try {
    await Hive.openBox<T>(name).timeout(timeout);
    return;
  } on TimeoutException {
    // fallthrough
  } catch (_) {
    // fallthrough
  }

  // 흔한 원인: 락 파일이 남아 openBox가 오래 걸리거나 실패
  // 복구 전략: 데이터는 유지하고 lock 파일만 best-effort로 제거 후 재시도
  await _tryDeleteHiveLockFile(name);

  try {
    await Hive.openBox<T>(name).timeout(timeout);
    return;
  } catch (_) {
    throw Exception('Hive 박스("$name")를 여는 데 실패했습니다.');
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Android 12+ 시스템 스플래시가 "첫 프레임"까지 유지되므로,
  // runApp을 최대한 빨리 호출하고 나머지 초기화는 앱 내부 로딩 화면에서 진행합니다.
  runApp(const AppBootstrapper());
}

class AppBootstrapper extends StatefulWidget {
  const AppBootstrapper({super.key});

  @override
  State<AppBootstrapper> createState() => _AppBootstrapperState();
}

class _AppBootstrapperState extends State<AppBootstrapper> {
  bool _initialized = false;
  String? _error;
  String _loadingStatus = '준비 중...';
  AppThemeViewModel? _themeVM;
  AppNotificationViewModel? _notificationVM;

  @override
  void initState() {
    super.initState();
    // Android 12+ 시스템 스플래시는 “첫 프레임”까지 유지되므로,
    // 첫 프레임 렌더 직후(post-frame)에 초기화를 시작합니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startInitialization();
    });
  }

  Future<void> _startInitialization() async {
    try {
      if (mounted) {
        setState(() => _loadingStatus = '데이터베이스 준비 중...');
      }
      // 저장소 초기화
      await Hive.initFlutter().timeout(const Duration(seconds: 6));

      // Hive 어댑터 등록
      Hive.registerAdapter(TodoModelAdapter());
      Hive.registerAdapter(GoalModelAdapter());
      Hive.registerAdapter(UserModelAdapter());
      Hive.registerAdapter(GoalStatusEnumAdapter());
      Hive.registerAdapter(CustomIconModelAdapter());

      if (mounted) {
        setState(() => _loadingStatus = '데이터 불러오는 중...');
      }
      // Hive 박스 열기 (병렬 + timeout/복구)
      await Future.wait([
        _openHiveBoxSafely<TodoModel>('todos'),
        _openHiveBoxSafely<TodoModel>('deleted_todos'),
        _openHiveBoxSafely<GoalModel>('goals'),
        _openHiveBoxSafely<UserModel>('user'),
        _openHiveBoxSafely<CustomIconModel>('custom_icons'),
      ]).timeout(const Duration(seconds: 8));

      if (mounted) {
        setState(() => _loadingStatus = '서비스 초기화 중...');
      }
      // 의존성 주입
      await configureAllDependencies().timeout(const Duration(seconds: 8));

      // 로케일 초기화는 실패해도 부팅은 계속
      try {
        await initializeDateFormatting('ko_KR', '')
            .timeout(const Duration(seconds: 4));
      } catch (_) {}

      if (mounted) {
        setState(() => _loadingStatus = '설정 불러오는 중...');
      }
      // 알림/테마 로드
      GetIt.I.registerLazySingleton<ReminderNotificationService>(
          () => ReminderNotificationService());
      final themeVM = GetIt.instance<AppThemeViewModel>();
      final notificationVM = GetIt.instance<AppNotificationViewModel>();
      await Future.wait([
        themeVM.load().timeout(const Duration(seconds: 4)),
        notificationVM.load().timeout(const Duration(seconds: 4)),
      ]);

      // 오디오는 기본 No-op으로 먼저 등록하고, 실제 엔진 초기화는 MyApp 첫 프레임 이후에 처리
      final enabledNow =
          notificationVM.settings.all && notificationVM.settings.sound;
      soundEnabled.value = enabledNow;
      audioGate = AudioGate(inner: NoopAudioEngine(), enabled: soundEnabled);
      if (!GetIt.I.isRegistered<AudioGate>()) {
        GetIt.I.registerSingleton<AudioGate>(audioGate);
      }

      // 세로모드만 허용 (앱이 이미 떠 있으므로 여기서 await해도 시스템 스플래시를 붙잡지 않음)
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      if (!mounted) return;
      setState(() {
        _themeVM = themeVM;
        _notificationVM = notificationVM;
        _initialized = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _FatalInitApp(
        message:
            '앱 초기화 중 문제가 발생했습니다.\n\n$_error\n\n해결이 안 되면: 설정 > 앱 > ToonDo > 저장공간에서 “데이터 삭제” 후 다시 실행해보세요.',
      );
    }

    if (!_initialized || _themeVM == null || _notificationVM == null) {
      final status = _loadingStatus;
      return MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  Text(
                    status,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return MyApp(themeVM: _themeVM!, notificationVM: _notificationVM!);
  }
}

class _FatalInitApp extends StatelessWidget {
  final String message;
  const _FatalInitApp({required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                message,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
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

    // 오디오 초기화는 첫 프레임 이후에 시도
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initAudioSafely();
    });

    widget.themeVM.addListener(() {
      setState(() {});
    });

    widget.notificationVM.addListener(() {
      final on = widget.notificationVM.settings.all &&
          widget.notificationVM.settings.sound;
      soundEnabled.value = on;
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var perm = await Permission.notification.status;
      if (!perm.isGranted) {
        perm = await Permission.notification.request();
      }

      if (perm.isGranted) {
        final vm = GetIt.I<AppNotificationViewModel>();
        final reminder = GetIt.I<ReminderNotificationService>();
        final s = vm.settings;
        await reminder.sync(
          enabledAll: s.all,
          enabledReminder: s.reminder,
          soundOn: s.sound,
          timeHHmm: s.time,
        );
      } else {
        debugPrint('[Reminder] Notification permission not granted');
      }
    });
  }

  Future<void> _initAudioSafely() async {
    try {
      final rawEngine = AudioEngine.init(2, AudioEngine.playbackSampleRate);
      if (rawEngine == null) return;
      final gate = AudioGate(inner: rawEngine, enabled: soundEnabled);

      if (GetIt.I.isRegistered<AudioGate>()) {
        GetIt.I.unregister<AudioGate>();
      }
      GetIt.I.registerSingleton<AudioGate>(gate);
    } catch (e) {
      debugPrint('[Audio] init failed (ignored): $e');
    }
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
              final feedbackOn = soundEnabled.value;
              final btnStyle = ButtonStyle(enableFeedback: feedbackOn);

              final light = ThemeData.light().copyWith(
                scaffoldBackgroundColor: const Color(0xFFFDFDFD),
                iconButtonTheme: IconButtonThemeData(style: btnStyle),
                textButtonTheme: TextButtonThemeData(style: btnStyle),
                elevatedButtonTheme: ElevatedButtonThemeData(style: btnStyle),
                outlinedButtonTheme: OutlinedButtonThemeData(style: btnStyle),
                listTileTheme: ListTileThemeData(enableFeedback: feedbackOn),
              );

              final dark = ThemeData.dark().copyWith(
                iconButtonTheme: IconButtonThemeData(style: btnStyle),
                textButtonTheme: TextButtonThemeData(style: btnStyle),
                elevatedButtonTheme: ElevatedButtonThemeData(style: btnStyle),
                outlinedButtonTheme: OutlinedButtonThemeData(style: btnStyle),
                listTileTheme: ListTileThemeData(enableFeedback: feedbackOn),
              );

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
                builder: (context, child) {
                  final mq = MediaQuery.of(context);
                  return MediaQuery(
                    data: mq.copyWith(textScaler: TextScaler.noScaling),
                    child: child!,
                  );
                },
                themeMode: vm.mode.toFlutterMode(),
                theme: light,
                darkTheme: dark,
                navigatorKey: navigatorKey,
                initialRoute: '/',
                onGenerateRoute: AppRouter.generateRoute,
              );
            },
          ),
        );
      },
    );
  }
}
