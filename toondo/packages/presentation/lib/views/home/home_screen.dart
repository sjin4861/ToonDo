import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:data/models/goal_status.dart';
import 'package:data/models/user_model.dart';
import 'package:presentation/viewmodels/character/slime_character_viewmodel.dart';
import 'package:presentation/viewmodels/goal/goal_viewmodel.dart';
// ...다른 ViewModel들 (홈, 목표관리 등)도 package:presentation/viewmodels/... 에서 임포트
import 'package:presentation/widgets/bottom_button/expandable_floating_button.dart';
import 'package:presentation/widgets/character/slime_area.dart';
import 'package:presentation/widgets/goal/goal_list_section.dart';
import 'package:presentation/widgets/character/background.dart';
import 'package:presentation/widgets/navigation/bottom_navigation_bar_widget.dart';
import 'package:get_it/get_it.dart';
import 'package:domain/usecases/auth/logout_usecase.dart';
import 'package:domain/usecases/gpt/get_gpt_response_usecase.dart';
import 'package:domain/usecases/user/get_user_nickname.dart';

class HomeScreen extends StatelessWidget {
  final bool isNewLogin;
  const HomeScreen({Key? key, this.isNewLogin = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hive에서 UserModel 사용
    final getUserNicknameUseCase = GetIt.instance<GetUserNicknameUseCase>();

    final String userNickname = getUserNicknameUseCase() as String;

    final goalVM = Provider.of<GoalViewModel>(context);
    // 진행 중 목표 필터링 및 정렬 (데이터 모델은 goal_model.dart 기준)
    final inProgressGoals = goalVM.goals
        .where((g) => g.status == GoalStatus.active)
        .toList();
    inProgressGoals.sort((a, b) => a.endDate.compareTo(b.endDate));
    final top3Goals = inProgressGoals.take(3).toList();

    // DI를 통한 domain/usecase 주입 (서비스 호출 대신)
    final getGptResponseUseCase = GetIt.instance<GetGptResponseUseCase>();

    // 슬라임 캐릭터 ViewModel DI (DI 컨테이너(GetIt) 사용 시 변경 가능)
    return ChangeNotifierProvider<SlimeCharacterViewModel>(
      create: (_) => SlimeCharacterViewModel(),
      child: Builder(
        builder: (context) {
          final slimeVM = Provider.of<SlimeCharacterViewModel>(context);
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('ToonDo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  key: const Key('logoutButton'),
                  icon: const Icon(Icons.exit_to_app, size: 24),
                  onPressed: () async {
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('로그아웃'),
                        content: const Text('정말 로그아웃 하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('로그아웃'),
                          ),
                        ],
                      ),
                    );
                    if (shouldLogout == true) {
                      // Service 대신 domain usecase 호출
                      await GetIt.instance<LogoutUseCase>()();
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  },
                ),
              ],
            ),
            body: Stack(
              children: [
                // 배경
                const HomeBackground(),
                // SafeArea 내 주요 콘텐츠
                SafeArea(
                  child: Column(
                    children: [
                      // 상단 목표 리스트 섹션
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: GoalListSection(topGoals: top3Goals),
                        ),
                      ),
                      // 하단 슬라임 캐릭터 영역
                      Expanded(
                        flex: 3,
                        child: SlimeArea(
                          characterViewModel: slimeVM,
                          userNickname: userNickname,
                          // usecase를 SlimeArea로 전달하도록 수정 (내부에서 getGptResponseUseCase 호출)
                          gptUseCase: getGptResponseUseCase,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: const ExpandableFab(),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: const BottomNavigationBarWidget(),
          );
        },
      ),
    );
  }
}