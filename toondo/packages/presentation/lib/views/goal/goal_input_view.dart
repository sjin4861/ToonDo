import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/usecases/goal/create_goal.dart';
import 'package:domain/usecases/goal/update_goal.dart';
import 'package:presentation/viewmodels/goal/goal_viewmodel.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/bottom_button/custom_button.dart';
import 'package:presentation/widgets/goal/goal_name_input_field.dart';
import 'package:presentation/widgets/goal/goal_input_date_field.dart';
import 'package:presentation/widgets/text_fields/tip.dart';

class GoalInputView extends StatelessWidget {
  final Goal? goal;

  const GoalInputView({super.key, this.goal});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoalViewModel>(
      create:
          (_) => GoalViewModel(
            GetIt.instance<CreateGoal>(),
            GetIt.instance<UpdateGoal>(),
            GetIt.instance<DeleteGoal>(),
            GetIt.instance<ReadGoals>(),
          ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFCFCFC),
        appBar: CustomAppBar(title: goal != null ? '목표 수정' : '목표 작성'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Consumer<GoalViewModel>(
            builder: (context, viewModel, child) {
              return SingleChildScrollView(
                child: Form(
                  key: GlobalKey<FormState>(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 목표 이름 입력 필드
                      GoalNameInputField(
                        controller: TextEditingController(
                          text: goal?.name ?? '',
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 날짜 입력 필드
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
              );
            },
          ),
        ),
        bottomNavigationBar: Consumer<GoalViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: CustomButton(
                text: '작성하기',
                onPressed: () async {
                  final form = Form.of(context);
                  if (form != null && form.validate()) {
                    form.save();
                    final newGoal = Goal(
                      name: viewModel.goalNameController.text,
                      startDate: viewModel.startDate!,
                      endDate: viewModel.endDate!,
                    );
                    if (goal != null) {
                      await viewModel.updateGoal(newGoal);
                    } else {
                      await viewModel.addGoal(newGoal);
                    }
                    Navigator.pop(context);
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
            );
          },
        ),
      ),
    );
  }
}
