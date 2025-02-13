// // screens/eisenhower_matrix_screen.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:toondo/models/todo.dart';
// import 'package:toondo/viewmodels/todo_viewmodel.dart'; // TodoViewModel 임포트
// import 'package:intl/intl.dart';
// import 'package:toondo/widgets/quadrant_widget.dart';
// import 'package:toondo/utils/color_utils.dart';

// class EisenhowerMatrixScreen extends StatefulWidget {
//   const EisenhowerMatrixScreen({Key? key}) : super(key: key);

//   @override
//   _EisenhowerMatrixScreenState createState() => _EisenhowerMatrixScreenState();
// }

// class _EisenhowerMatrixScreenState extends State<EisenhowerMatrixScreen> {
//   DateTime selectedDate = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     // 모든 투두 리스트 로드
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<TodoViewModel>(context, listen: false).loadTodos();
//     });
//   }

//   // 분류된 투두 리스트
//   List<Todo> getTodosByQuadrant(List<Todo> todos, String quadrant) {
//     switch (quadrant) {
//       case 'urgentImportant':
//         return todos
//             .where((todo) => todo.urgency >= 5.0 && todo.importance >= 5.0)
//             .toList()
//           ..sort(_sortTodos);
//       case 'notUrgentImportant':
//         return todos
//             .where((todo) => todo.urgency < 5.0 && todo.importance >= 5.0)
//             .toList()
//           ..sort(_sortTodos);
//       case 'urgentNotImportant':
//         return todos
//             .where((todo) => todo.urgency >= 5.0 && todo.importance < 5.0)
//             .toList()
//           ..sort(_sortTodos);
//       case 'notUrgentNotImportant':
//         return todos
//             .where((todo) => todo.urgency < 5.0 && todo.importance < 5.0)
//             .toList()
//           ..sort(_sortTodos);
//       default:
//         return [];
//     }
//   }

//   // 투두 정렬 함수
//   int _sortTodos(Todo a, Todo b) {
//     if (a.importance != b.importance) {
//       return b.importance.compareTo(a.importance); // 중요도가 높을수록 먼저
//     }
//     return b.urgency.compareTo(a.urgency); // 긴급도가 높을수록 먼저
//   }

//   // 카테고리에 따른 최소값 설정
//   Map<String, double> getMinValues(String quadrant) {
//     switch (quadrant) {
//       case 'urgentImportant':
//         return {'urgency': 5.0, 'importance': 5.0};
//       case 'notUrgentImportant':
//         return {'urgency': 0.0, 'importance': 5.0};
//       case 'urgentNotImportant':
//         return {'urgency': 5.0, 'importance': 0.0};
//       case 'notUrgentNotImportant':
//         return {'urgency': 0.0, 'importance': 0.0};
//       default:
//         return {'urgency': 0.0, 'importance': 0.0};
//     }
//   }

//   // Todo 이동 처리
//   void _moveTodo(Todo todo, String quadrant) async {
//     Map<String, double> minValues = getMinValues(quadrant);
//     double initialUrgency = minValues['urgency']!;
//     double initialImportance = minValues['importance']!;

//     showDialog(
//       context: context,
//       builder: (context) {
//         double newUrgency = initialUrgency;
//         double newImportance = initialImportance;
//         return StatefulBuilder(
//           builder: (context, setStateDialog) {
//             return AlertDialog(
//               title: Text('긴급도와 중요도 수정'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // 긴급도 슬라이더
//                   Text('긴급도: ${newUrgency.toStringAsFixed(1)}'),
//                   Slider(
//                     value: newUrgency,
//                     min: minValues['urgency']!,
//                     max: 10.0,
//                     divisions:
//                         ((10.0 - minValues['urgency']!) * 10).round(),
//                     label: newUrgency.toStringAsFixed(1),
//                     onChanged: (double value) {
//                       setStateDialog(() {
//                         newUrgency = double.parse(value.toStringAsFixed(1));
//                       });
//                     },
//                   ),
//                   SizedBox(height: 20),
//                   // 중요도 슬라이더
//                   Text('중요도: ${newImportance.toStringAsFixed(1)}'),
//                   Slider(
//                     value: newImportance,
//                     min: minValues['importance']!,
//                     max: 10.0,
//                     divisions:
//                         ((10.0 - minValues['importance']!) * 10).round(),
//                     label: newImportance.toStringAsFixed(1),
//                     onChanged: (double value) {
//                       setStateDialog(() {
//                         newImportance =
//                             double.parse(value.toStringAsFixed(1));
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text('취소'),
//                 ),
//                 TextButton(
//                   onPressed: () async {
//                     // Todo 업데이트
//                     todo.urgency = newUrgency;
//                     todo.importance = newImportance;
//                     await Provider.of<TodoViewModel>(context, listen: false)
//                         .updateTodo(todo);
//                     Navigator.pop(context);
//                   },
//                   child: Text('저장'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   // Todo 상세 내용 표시
//   void _showTodoDetails(Todo todo) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(todo.title),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('코멘트: ${todo.comment}'),
//               SizedBox(height: 8),
//               Text('긴급도: ${todo.urgency.toStringAsFixed(1)}'),
//               Text('중요도: ${todo.importance.toStringAsFixed(1)}'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('닫기'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // 날짜 선택 함수
//   Future<void> _selectDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   // 다음날로 이동
//   void _goToNextDay() {
//     setState(() {
//       selectedDate = selectedDate.add(Duration(days: 1));
//     });
//   }

//   // 이전날로 이동
//   void _goToPreviousDay() {
//     setState(() {
//       selectedDate = selectedDate.subtract(Duration(days: 1));
//     });
//   }

//   // Todo 목록에서 긴급도와 중요도를 수정하는 함수
//   void _editTodoFromList(Todo todo) async {
//     showDialog(
//       context: context,
//       builder: (context) {
//         double newUrgency = todo.urgency;
//         double newImportance = todo.importance;
//         return StatefulBuilder(
//           builder: (context, setStateDialog) {
//             return AlertDialog(
//               title: Text('긴급도와 중요도 수정'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // 긴급도 슬라이더
//                   Text('긴급도: ${newUrgency.toStringAsFixed(1)}'),
//                   Slider(
//                     value: newUrgency,
//                     min: 0.0,
//                     max: 10.0,
//                     divisions: 100, // 0.1 단위
//                     label: newUrgency.toStringAsFixed(1),
//                     onChanged: (double value) {
//                       setStateDialog(() {
//                         newUrgency = double.parse(value.toStringAsFixed(1));
//                       });
//                     },
//                   ),
//                   SizedBox(height: 20),
//                   // 중요도 슬라이더
//                   Text('중요도: ${newImportance.toStringAsFixed(1)}'),
//                   Slider(
//                     value: newImportance,
//                     min: 0.0,
//                     max: 10.0,
//                     divisions: 100, // 0.1 단위
//                     label: newImportance.toStringAsFixed(1),
//                     onChanged: (double value) {
//                       setStateDialog(() {
//                         newImportance =
//                             double.parse(value.toStringAsFixed(1));
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text('취소'),
//                 ),
//                 TextButton(
//                   onPressed: () async {
//                     // Todo 업데이트
//                     todo.urgency = newUrgency;
//                     todo.importance = newImportance;
//                     await Provider.of<TodoViewModel>(context, listen: false)
//                         .updateTodo(todo);
//                     Navigator.pop(context);
//                   },
//                   child: Text('저장'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   // 날짜 기준 아이젠하워 매트릭스 제목 표시
//   String getDateLabel(DateTime date) {
//     DateTime today = DateTime.now();
//     DateTime tomorrow = today.add(Duration(days: 1));

//     if (isSameDate(date, today)) {
//       return '오늘';
//     } else if (isSameDate(date, tomorrow)) {
//       return '내일';
//     } else if (date.isBefore(today)) {
//       return '과거 (${DateFormat('yyyy-MM-dd').format(date)})';
//     } else {
//       return '미래 (${DateFormat('yyyy-MM-dd').format(date)})';
//     }
//   }

//   bool isSameDate(DateTime date1, DateTime date2) {
//     return date1.year == date2.year &&
//         date1.month == date2.month &&
//         date1.day == date2.day;
//   }

//   @override
//   Widget build(BuildContext context) {
//     String dateLabel = getDateLabel(selectedDate);

//     // ViewModel에서 투두 리스트 가져오기
//     final todoViewModel = Provider.of<TodoViewModel>(context);
//     final todos = todoViewModel.getTodosForDate(selectedDate);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(dateLabel),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.calendar_today),
//             onPressed: _selectDate,
//             tooltip: '날짜 선택',
//           ),
//           IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: _goToPreviousDay,
//             tooltip: '이전날',
//           ),
//           IconButton(
//             icon: Icon(Icons.arrow_forward),
//             onPressed: _goToNextDay,
//             tooltip: '다음날',
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // 아이젠하워 매트릭스 그리드
//           Expanded(
//             flex: 2,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: GridView.count(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 8.0,
//                 mainAxisSpacing: 8.0,
//                 children: [
//                   // 왼쪽 상단: 긴급하고 중요한 일
//                   QuadrantWidget(
//                     title: '긴급하고 중요한 일',
//                     todos: getTodosByQuadrant(todos, 'urgentImportant'),
//                     color: Colors.redAccent,
//                     quadrant: 'urgentImportant',
//                     onMoveTodo: _moveTodo,
//                     onShowDetails: _showTodoDetails,
//                   ),
//                   // 오른쪽 상단: 긴급하지 않지만 중요한 일
//                   QuadrantWidget(
//                     title: '긴급하지 않지만 중요한 일',
//                     todos: getTodosByQuadrant(todos, 'notUrgentImportant'),
//                     color: Colors.orangeAccent,
//                     quadrant: 'notUrgentImportant',
//                     onMoveTodo: _moveTodo,
//                     onShowDetails: _showTodoDetails,
//                   ),
//                   // 왼쪽 하단: 긴급하지만 중요하지 않은 일
//                   QuadrantWidget(
//                     title: '긴급하지만 중요하지 않은 일',
//                     todos: getTodosByQuadrant(todos, 'urgentNotImportant'),
//                     color: Colors.lightBlueAccent,
//                     quadrant: 'urgentNotImportant',
//                     onMoveTodo: _moveTodo,
//                     onShowDetails: _showTodoDetails,
//                   ),
//                   // 오른쪽 하단: 긴급하지도 중요하지도 않은 일
//                   QuadrantWidget(
//                     title: '긴급하지도 중요하지도 않은 일',
//                     todos: getTodosByQuadrant(todos, 'notUrgentNotImportant'),
//                     color: Colors.greenAccent,
//                     quadrant: 'notUrgentNotImportant',
//                     onMoveTodo: _moveTodo,
//                     onShowDetails: _showTodoDetails,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Divider(),
//           // Todo 목록
//           Expanded(
//             flex: 1,
//             child: Column(
//               children: [
//                 Text(
//                   '모든 Todo 목록',
//                   style:
//                       TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Expanded(
//                   child: todos.isNotEmpty
//                       ? ListView.builder(
//                           itemCount: todos.length,
//                           itemBuilder: (context, index) {
//                             Todo todo = todos[index];
//                             return ListTile(
//                               leading: CircleAvatar(
//                                 backgroundColor: getColor(todo),
//                                 child: Text(
//                                   todo.title.isNotEmpty
//                                       ? todo.title[0].toUpperCase()
//                                       : 'T',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                               title: Text(todo.title),
//                               subtitle: Text(
//                                   '긴급도: ${todo.urgency.toStringAsFixed(1)}, 중요도: ${todo.importance.toStringAsFixed(1)}'),
//                               trailing: IconButton(
//                                 icon: Icon(Icons.edit),
//                                 onPressed: () {
//                                   _editTodoFromList(todo);
//                                 },
//                               ),
//                               onTap: () {
//                                 _showTodoDetails(todo);
//                               },
//                             );
//                           },
//                         )
//                       : Center(
//                           child: Text(
//                             '할 일이 없습니다.',
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(
//             context,
//             '/todo',
//             arguments: selectedDate, // 현재 선택된 날짜 전달
//           ).then((_) {
//             // 투두 리스트를 다시 로드
//             todoViewModel.loadTodos();
//           });
//         },
//         child: Icon(Icons.add),
//         tooltip: '투두 추가',
//       ),
//     );
//   }
// }