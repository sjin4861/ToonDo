// // lib/views/todo/todo_submission_screen.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:toondo/data/models/goal.dart';
// import 'package:toondo/data/models/todo.dart';
// import 'package:toondo/viewmodels/goal/goal_viewmodel.dart';
// import 'package:toondo/viewmodels/todo/todo_submission_viewmodel.dart';
// import 'package:toondo/services/todo_service.dart';
// import 'package:toondo/viewmodels/todo/todo_viewmodel.dart';
// import 'package:intl/intl.dart';
// import 'package:toondo/widgets/app_bar/custom_app_bar.dart';
// import 'package:toondo/widgets/top_menu_bar/menu_bar.dart';
// import 'todo_input_screen.dart'; // TodoInputScreen 임포트
// import 'package:toondo/widgets/calendar/calendar.dart'; // Calendar 위젯 임포트
// import 'package:toondo/widgets/todo/todo_list_item.dart'; // TodoListItem 임포트

// class TodoSubmissionScreen extends StatelessWidget {
//   final DateTime? selectedDate;

//   const TodoSubmissionScreen({Key? key, this.selectedDate}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // TodoService 인스턴스를 Provider로부터 가져옵니다.
//     final TodoService todoService = Provider.of<TodoService>(context, listen: false);

//     return ChangeNotifierProvider<TodoSubmissionViewModel>(
//       create: (_) => TodoSubmissionViewModel(
//         todoService: todoService,
//         initialDate: selectedDate,
//       )..loadTodos(),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: CustomAppBar(
//           title: '투두리스트',
//         ),  
//         body: Consumer<TodoSubmissionViewModel>(
//           builder: (context, viewModel, child) {
//             final goalViewmodel = Provider.of<GoalViewModel>(context);
//             List<Goal> goals = goalViewmodel.goals;

//             return Column(
//               children: [
//                 // 캘린더 위젯
//                 Calendar(
//                   selectedDate: viewModel.selectedDate,
//                   onDateSelected: (date) {
//                     viewModel.updateSelectedDate(date);
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 // 2) MenuBarWidget으로 교체
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 28),
//                   child: MenuBarWidget(
//                     selectedMenu: _filterOptionToMenuOption(viewModel.selectedFilter),
//                     onItemSelected: (option) {
//                       // MenuOption → FilterOption 으로 변환
//                       final filter = _menuOptionToFilterOption(option);
//                       viewModel.updateSelectedFilter(filter);
//                     },
//                   ),
//                 ),
//                 // 목표 선택 바
//                 if (viewModel.selectedFilter == FilterOption.goal)
//                   _buildGoalSelectionBar(viewModel, goals),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         _buildTodoSection(context, '디데이 투두', viewModel.dDayTodos, viewModel, isDDay: true),
//                         _buildTodoSection(context, '데일리 투두', viewModel.dailyTodos, viewModel, isDDay: false),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // 탭 바 자리
//                 Container(
//                   height: 64,
//                   decoration: const BoxDecoration(
//                     color: Color(0xFFFCFCFC),
//                     border: Border(
//                       top: BorderSide(width: 1, color: Color(0x3F1C1D1B)),
//                     ),
//                   ),
//                   // 필요한 위젯 추가
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//   // 3) FilterOption ↔ MenuOption 변환 함수
//   MenuOption _filterOptionToMenuOption(FilterOption filter) {
//     switch (filter) {
//       case FilterOption.all:
//         return MenuOption.all;
//       case FilterOption.goal:
//         return MenuOption.goal;
//       case FilterOption.importance:
//         return MenuOption.importance;
//     }
//   }

//   FilterOption _menuOptionToFilterOption(MenuOption option) {
//     switch (option) {
//       case MenuOption.all:
//         return FilterOption.all;
//       case MenuOption.goal:
//         return FilterOption.goal;
//       case MenuOption.importance:
//         return FilterOption.importance;
//     }
//   }

//   Widget _buildGoalSelectionBar(TodoSubmissionViewModel viewModel, List<Goal> goals) {
//     return Container(
//       height: 40,
//       margin: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: goals.length,
//         itemBuilder: (context, index) {
//           Goal goal = goals[index];
//           bool isSelected = viewModel.selectedGoalId == goal.id;
//           return GestureDetector(
//             onTap: () {
//               viewModel.updateSelectedFilter(FilterOption.goal, goalId: goal.id);
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               margin: EdgeInsets.symmetric(horizontal: 4),
//               decoration: BoxDecoration(
//                 color: isSelected ? Color(0xFF78B545) : Colors.transparent,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Color(0xFFE4F0D9)),
//               ),
//               child: Center(
//                 child: Text(
//                   goal.name,
//                   style: TextStyle(
//                     color: isSelected ? Colors.white : Colors.black.withOpacity(0.5),
//                     fontSize: 14,
//                     fontFamily: 'Pretendard Variable',
//                     fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
//                     letterSpacing: 0.21,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTodoSection(
//     BuildContext context,
//     String title,
//     List<Todo> todos,
//     TodoSubmissionViewModel viewModel, {
//     required bool isDDay,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 섹션 헤더
//           GestureDetector(
//             key: Key('addTodoButton'),
//             onTap: () {
//               // 투두 추가 페이지로 이동
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => TodoInputScreen(
//                     isDDayTodo: isDDay,
//                   ),
//                 ),
//               ).then((_) {
//                 viewModel.loadTodos();
//               });
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               decoration: ShapeDecoration(
//                 shape: RoundedRectangleBorder(
//                   side: BorderSide(width: 0.5, color: Color(0x3F1C1D1B)),
//                   borderRadius: BorderRadius.circular(1000),
//                 ),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       color: Color(0xFF1C1D1B),
//                       fontSize: 11,
//                       fontWeight: FontWeight.w600,
//                       letterSpacing: 0.17,
//                       fontFamily: 'Pretendard Variable',
//                     ),
//                   ),
//                   const SizedBox(width: 4),
//                   Icon(Icons.add, size: 12, color: Color(0xFF1C1D1B)),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           // 투두 리스트
//           todos.isNotEmpty
//               ? ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: todos.length,
//                   itemBuilder: (context, index) {
//                     Todo todo = todos[index];
//                     return _buildTodoItem(context, todo, viewModel, isDDay: isDDay);
//                   },
//                 )
//               : Text('투두가 없습니다.', style: TextStyle(color: Colors.grey))
// ,
//         ],
//       ),
//     );
//   }

//   Widget _buildTodoItem(
//     BuildContext context,
//     Todo todo,
//     TodoSubmissionViewModel viewModel, {
//     required bool isDDay,
//   }) {
//     DateTime selectedDateOnly = DateTime(
//       viewModel.selectedDate.year,
//       viewModel.selectedDate.month,
//       viewModel.selectedDate.day,
//     );

//     return TodoListItem(
//       todo: todo,
//       selectedDate : selectedDateOnly,
//       onUpdate: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TodoInputScreen(
//               isDDayTodo: todo.isDDayTodo(),
//               todo: todo,
//             ),
//           ),
//         ).then((_) {
//           // 투두 목록 갱신
//           viewModel.loadTodos();
//         });
//       },
//       onStatusUpdate: (Todo updatedTodo, double newStatus) {
//         viewModel.updateTodoStatus(updatedTodo, newStatus);
//       },
//       onDelete: () => viewModel.deleteTodoById(todo.id),
//       onPostpone : () {
//         DateTime newStartDate = todo.startDate.add(Duration(days: 1));
//         DateTime newEndDate = todo.endDate.add(Duration(days: 1));
//         viewModel.updateTodoDates(todo, newStartDate, newEndDate);
//       },
//       hideCompletionStatus: isDDay, // D-Day 투두에서는 진행률을 숨기지 않음
//     );
//   }
// }