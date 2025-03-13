import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/goal/goal_viewmodel.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/goal/goal_list_item.dart';
import 'package:presentation/views/goal/goal_input_view.dart';

class GoalManageView extends StatelessWidget {
  const GoalManageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoalViewModel>(
      create:
          (_) => GoalViewModel(
            GetIt.instance<CreateGoal>(),
            GetIt.instance<UpdateGoal>(),
            GetIt.instance<DeleteGoal>(),
            GetIt.instance<ReadGoals>(),
          )..loadGoals(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFCFCFC),
        appBar: CustomAppBar(title: '목표 관리'),
        body: Consumer<GoalViewModel>(
          builder: (context, viewModel, child) {
            return ListView.builder(
              itemCount: viewModel.goals.length,
              itemBuilder: (context, index) {
                final goal = viewModel.goals[index];
                return GoalListItem(
                  goal: goal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GoalInputView(goal: goal),
                      ),
                    ).then((_) => viewModel.loadGoals());
                  },
                  onDelete: () async {
                    await viewModel.deleteGoal(goal.id);
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GoalInputView()),
            ).then((_) => context.read<GoalViewModel>().loadGoals());
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
