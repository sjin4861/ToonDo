import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/character/chat_viewmodel.dart';
import 'package:presentation/viewmodels/welcome/welcome_viewmodel.dart';
import 'package:presentation/views/chat/slime_chat_page.dart';
import 'package:presentation/views/mypage/account_setting/account_setting_screen.dart';
import 'package:presentation/views/mypage/account_setting/nickname_change_screen.dart';
import 'package:presentation/views/mypage/account_setting/password_change_screen.dart';
import 'package:presentation/views/mypage/account_setting/phone_number_change_screen.dart';
import 'package:presentation/views/mypage/display_setting/display_setting_screen.dart';
import 'package:presentation/views/mypage/help_guide/help_guide_screen.dart';
import 'package:presentation/views/mypage/notification_setting/notification_setting_screen.dart';
import 'package:presentation/views/todo/todo_manage_screen.dart';
import 'package:provider/provider.dart';
import 'package:presentation/views/home/home_screen.dart';
import 'package:presentation/views/goal/goal_progress_screen.dart';
import 'package:presentation/views/welcome/welcome_screen.dart';
import 'package:presentation/views/auth/signup_screen.dart';
import 'package:presentation/navigation/route_paths.dart';
import 'package:presentation/views/goal/goal_manage_view.dart';
import 'package:presentation/views/goal/goal_input_view.dart';
import 'package:presentation/views/mypage/my_page_screen.dart';
import 'package:get_it/get_it.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.root:
        return MaterialPageRoute(
          builder:
              (_) => ChangeNotifierProvider<WelcomeViewModel>.value(
                value: GetIt.instance<WelcomeViewModel>(),
                child: WelcomeScreen(),
              ),
        );
      case RoutePaths.signup:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case RoutePaths.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RoutePaths.goalManage:
        return MaterialPageRoute(builder: (_) => GoalManageView());
      case RoutePaths.goalInput:
        return MaterialPageRoute(builder: (_) => GoalInputView());
      case RoutePaths.goalAnalisys:
        return MaterialPageRoute(builder: (_) => GoalProgressScreen());
      case RoutePaths.todoManage:
        return MaterialPageRoute(builder: (_) => TodoManageScreen());
      case RoutePaths.mypage:
        return MaterialPageRoute(builder: (_) => MyPageScreen());
      case RoutePaths.notificationSetting:
        return MaterialPageRoute(builder: (_) => NotificationSettingScreen());
      case RoutePaths.displaySetting:
        return MaterialPageRoute(builder: (_) => DisplaySettingScreen());
      case RoutePaths.accountSetting:
        return MaterialPageRoute(builder: (_) => AccountSettingScreen());
      case RoutePaths.helpGuide:
        return MaterialPageRoute(builder: (_) => HelpGuideScreen());
      case RoutePaths.accountSettingNicknameChange:
        return MaterialPageRoute(builder: (_) => NicknameChangeScreen());
      case RoutePaths.accountSettingPhoneChange:
        return MaterialPageRoute(builder: (_) => PhoneNumberChangeScreen());
      case RoutePaths.accountSettingPasswordChange:
        return MaterialPageRoute(builder: (_) => PasswordChangeScreen());
      case RoutePaths.slimeChat:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider<ChatViewModel>.value(
            value: GetIt.instance<ChatViewModel>(),
            child: const SlimeChatPage(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('404: ${settings.name} 라우트를 찾을 수 없습니다.'),
                ),
              ),
        );
    }
  }
}
