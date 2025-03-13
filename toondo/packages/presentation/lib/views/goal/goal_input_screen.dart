// // lib/views/goal/goal_input_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart';
// import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
// import 'package:presentation/widgets/bottom_button/custom_button.dart';
// import 'package:presentation/widgets/calendar/calendar_bottom_sheet.dart';
// import 'package:presentation/widgets/goal/goal_icon_bottom_sheet.dart';
// import 'package:presentation/widgets/text_fields/goal_name_input_field.dart';
// import 'package:presentation/widgets/goal/goal_input_date_field.dart';
// import 'package:presentation/widgets/text_fields/tip.dart';
// import 'package:presentation/widgets/goal/goal_setting_bottom_sheet.dart';

// class GoalInputScreen extends StatelessWidget {
//   final dynamic targetGoal; // domain/entity or null
//   const GoalInputScreen({Key? key, this.targetGoal}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<GoalInputViewModel>(
//       create: (_) => GoalInputViewModel(targetGoal: targetGoal),
//       child: _GoalInputScreenBody(),
//     );
//   }
// }

// class _GoalInputScreenBody extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<GoalInputViewModel>(context);
//     return Scaffold(
//       backgroundColor: const Color(0xFFFCFCFC),
//       appBar: CustomAppBar(title: '목표 설정하기'),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 상단 안내 문구
//               Text(
//                 '목표를 정해 볼까요?',
//                 style: TextStyle(
//                   color: const Color(0xFF78B545),
//                   fontSize: 16,
//                   fontFamily: 'Pretendard Variable',
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: 0.24,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 '앞으로 툰두와 함께 달려 나갈 목표를 알려주세요.',
//                 style: TextStyle(
//                   color: const Color(0xBF1C1D1B),
//                   fontSize: 10,
//                   fontFamily: 'Pretendard Variable',
//                   fontWeight: FontWeight.w400,
//                   letterSpacing: 0.15,
//                 ),
//               ),
//               const SizedBox(height: 32),
//               // 목표 이름 입력 필드
//               GoalNameInputField(
//                 controller: viewModel.goalNameController,
//                 errorText: viewModel.goalNameError,
//               ),
//               const SizedBox(height: 32),
//               // 시작일과 마감일 선택
//               Row(
//                 children: [
//                   Expanded(
//                     child: GoalInputDateField(
//                       label: '시작일',
//                       onDateSelected: (date) => viewModel.selectStartDate(date),
//                       selectedDate: viewModel.startDate,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: GoalInputDateField(
//                       label: '마감일',
//                       onDateSelected: (date) => viewModel.selectEndDate(date),
//                       selectedDate: viewModel.endDate,
//                     ),
//                   ),
//                 ],
//               ),
//               if (viewModel.dateError != null) ...[
//                 const SizedBox(height: 4),
//                 Text(
//                   viewModel.dateError!,
//                   style: TextStyle(
//                     color: const Color(0xFFEE0F12),
//                     fontSize: 10,
//                     fontFamily: 'Pretendard Variable',
//                     fontWeight: FontWeight.w400,
//                     letterSpacing: 0.15,
//                   ),
//                 ),
//               ],
//               const SizedBox(height: 32),
//               // TIP 문구
//               const TipWidget(
//                 title: 'TIP',
//                 description: '결과를 측정할 수 있고 달성이 가능한 목표를 세워보세요!',
//               ),
//               const SizedBox(height: 32),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
//         child: CustomButton(
//           text: '작성하기',
//           onPressed: () async {
//             final newGoal = await viewModel.saveGoal(context);
//             if (newGoal != null) {
//               showModalBottomSheet(
//                 context: context,
//                 isScrollControlled: true,
//                 builder: (context) => GoalSettingBottomSheet(goal: newGoal),
//               );
//             }
//           },
//           backgroundColor: const Color(0xFF78B545),
//           textColor: const Color(0xFFFCFCFC),
//           fontSize: 16,
//           fontWeight: FontWeight.w700,
//           letterSpacing: 0.24,
//           padding: 16.0,
//           borderRadius: BorderRadius.circular(30),
//         ),
//       ),
//     );
//   }
// }
