import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/usecases/goal/create_goal_remote.dart';
import 'package:domain/usecases/goal/save_goal_local.dart';
import 'package:domain/usecases/goal/update_goal_remote.dart';
import 'package:domain/usecases/goal/update_goal_local.dart';
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/bottom_button/custom_button.dart';
import 'package:presentation/widgets/text_fields/goal_name_input_field.dart';
import 'package:presentation/widgets/goal/goal_input_date_field.dart';
import 'package:presentation/widgets/text_fields/tip.dart';
import 'package:presentation/widgets/goal/goal_setting_bottom_sheet.dart';

class GoalInputView extends StatelessWidget {
  final Goal? goal;

  const GoalInputView({Key? key, this.goal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoalInputViewModel>(
      create: (_) => GoalInputViewModel(
        createGoalRemoteUseCase: GetIt.instance<CreateGoalRemoteUseCase>(),
        saveGoalLocalUseCase: GetIt.instance<SaveGoalLocalUseCase>(),
        updateGoalRemoteUseCase: GetIt.instance<UpdateGoalRemoteUseCase>(),
        updateGoalLocalUseCase: GetIt.instance<UpdateGoalLocalUseCase>(),
        targetGoal: goal,
      ),
      child: const _GoalInputViewBody(),
    );
  }
}

class _GoalInputViewBody extends StatelessWidget {
  const _GoalInputViewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GoalInputViewModel>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: CustomAppBar(title: viewModel.targetGoal != null ? '목표 수정' : '목표 작성'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: SingleChildScrollView(
          child: Form(
            key: GlobalKey<FormState>(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 목표 이름 입력 필드 (ViewModel의 controller와 에러 사용)
                GoalNameInputField(
                  controller: viewModel.goalNameController,
                  errorText: viewModel.goalNameError,
                ),
                const SizedBox(height: 24),
                // 날짜 입력 필드 (ViewModel을 통해 값 관리)
                Row(
                  children: [
                    Expanded(
                      child: GoalInputDateField(
                        viewModel: viewModel,
                        label: '시작일',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GoalInputDateField(
                        viewModel: viewModel,
                        label: '마감일',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // TIP 위젯
                const TipWidget(
                  title: 'TIP',
                  description: '결과를 측정할 수 있고 달성이 가능한 목표를 세워보세요!',
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: CustomButton(
          text: '작성하기',
          onPressed: () async {
            final newGoal = await viewModel.saveGoal(context);
            if (newGoal != null) {
              // 이전 화면으로 돌아가면서 콜백 실행
              Navigator.pop(context, newGoal);
              // Home과 GoalManage 갱신
              GetIt.instance<HomeViewModel>().loadGoals();
              GetIt.instance<GoalManagementViewModel>().loadGoals();
              // BottomSheet은 rootNavigator로 띄워 상위 스코프에서 표시
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useRootNavigator: true,
                builder: (_) => GoalSettingBottomSheet(goal: newGoal),
              );
            }
          },
          backgroundColor: const Color(0xFF78B545),
          textColor: const Color(0xFFFCFCFC),
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.24,
          padding: 16.0,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
