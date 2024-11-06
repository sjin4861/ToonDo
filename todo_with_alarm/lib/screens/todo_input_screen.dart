import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/providers/goal_provider.dart';
import 'package:todo_with_alarm/providers/todo_provider.dart';
import 'package:intl/intl.dart';

class TodoInputScreen extends StatefulWidget {
  final bool isDDayTodo;
  final Todo? todo;

  const TodoInputScreen({Key? key, this.isDDayTodo = true, this.todo}) : super(key: key);

  @override
  _TodoInputScreenState createState() => _TodoInputScreenState();
}

class _TodoInputScreenState extends State<TodoInputScreen> {

  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String? _selectedGoalId;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isDailyTodo = false;
  int _priority = 0; // 중요도 (0: 선택 안 함, 1~3: 선택한 별의 개수)
  final _titleController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');


  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      // 수정 모드
      _titleController.text = widget.todo!.title;
      _selectedGoalId = widget.todo!.goalId;
      _startDate = widget.todo!.startDate;
      _endDate = widget.todo!.endDate;
      _priority = widget.todo!.importance.toInt();
      _isDailyTodo = widget.todo!.startDate == widget.todo!.endDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isDDayTodo ? '디데이 투두 작성' : '데일리 투두 작성'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // To-Do 페이지로 이동
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 투두 이름 입력
              TextFormField(
                controller: _titleController,
                maxLength: 20,
                decoration: InputDecoration(
                  labelText: '투두 이름',
                  hintText: '투두의 이름을 지어주세요.',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '투두 이름을 입력해주세요.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!.trim();
                },
              ),
              SizedBox(height: 24),
              // 목표 선택
              GestureDetector(
                onTap: () {
                  _showGoalSelectionDialog(goalProvider.goals);
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: '목표',
                      hintText: _selectedGoalId != null
                          ? goalProvider.goals
                              .firstWhere((goal) => goal.id == _selectedGoalId)
                              .name
                          : '목표를 선택해주세요.',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              // 시작일 및 마감일 선택
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(isStartDate: true),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: '시작일',
                            hintText: _startDate != null
                                ? _dateFormat.format(_startDate!)
                                : '시작일을 선택해주세요.',
                          ),
                          validator: (value) {
                            if (!_isDailyTodo && _startDate == null) {
                              return '시작일을 선택해주세요.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(isStartDate: false),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: '마감일',
                            hintText: _endDate != null
                                ? _dateFormat.format(_endDate!)
                                : '마감일을 선택해주세요.',
                          ),
                          validator: (value) {
                            if (!_isDailyTodo && _endDate == null) {
                              return '마감일을 선택해주세요.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // 데일리 투두로 설정
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('데일리 투두로 설정'),
                  Checkbox(
                    value: _isDailyTodo,
                    onChanged: (value) {
                      setState(() {
                        _isDailyTodo = value!;
                        if (_isDailyTodo) {
                          _startDate = DateTime.now();
                          _endDate = DateTime.now();
                        } else {
                          _startDate = null;
                          _endDate = null;
                        }
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 24),
              // 중요도 선택
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('중요도'),
                  SizedBox(height: 8),
                  Row(
                    children: List.generate(3, (index) {
                      int starIndex = index + 1;
                      return IconButton(
                        icon: Icon(
                          Icons.star,
                          color: _priority >= starIndex
                              ? _getPriorityColor(starIndex)
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _priority = starIndex;
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: 24),
              // 작성하기 버튼
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // 투두 생성 및 저장
                    Todo newTodo = Todo(
                      title: _title,
                      startDate: _isDailyTodo
                          ? DateTime.now()
                          : _startDate ?? DateTime.now(),
                      endDate: _isDailyTodo
                          ? DateTime.now()
                          : _endDate ?? DateTime.now(),
                      goalId: _selectedGoalId,
                      importance: _priority.toDouble(),
                      // 기타 필요한 필드 설정
                    );
                    if (widget.todo != null) {
                      // 수정 모드
                      Provider.of<TodoProvider>(context, listen: false).updateTodo(newTodo);
                    } else {
                      // 새로 추가
                      Provider.of<TodoProvider>(context, listen: false).addTodo(newTodo);
                    }
                    Navigator.pop(context); // 투두 페이지로 돌아가기
                  }
                },
                child: Text(widget.todo != null ? '수정하기' : '작성하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 목표 선택 다이얼로그
  void _showGoalSelectionDialog(List<Goal> goals) {
    showDialog(
      context: context,
      builder: (context) {
        String? tempSelectedGoalId = _selectedGoalId;
        return AlertDialog(
          title: Text('목표 선택'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                RadioListTile<String?>(
                  title: Text('목표 미설정'),
                  value: null,
                  groupValue: tempSelectedGoalId,
                  onChanged: (value) {
                    setState(() {
                      tempSelectedGoalId = value;
                    });
                    Navigator.pop(context);
                    setState(() {
                      _selectedGoalId = tempSelectedGoalId;
                    });
                  },
                ),
                ...goals.map((goal) {
                  return RadioListTile<String?>(
                    title: Text(goal.name),
                    value: goal.id,
                    groupValue: tempSelectedGoalId,
                    onChanged: (value) {
                      setState(() {
                        tempSelectedGoalId = value;
                      });
                      Navigator.pop(context);
                      setState(() {
                        _selectedGoalId = tempSelectedGoalId;
                      });
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  // 날짜 선택 Bottom Sheet
  void _selectDate({required bool isStartDate}) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2020);
    DateTime lastDate = DateTime(2030);

    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        DateTime tempPickedDate = initialDate;
        return Container(
          height: 250,
          child: Column(
            children: [
              Expanded(
                child: CalendarDatePicker(
                  initialDate: initialDate,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  onDateChanged: (date) {
                    tempPickedDate = date;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, tempPickedDate);
                },
                child: Text('선택하기'),
              ),
            ],
          ),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
          if (_endDate != null && _startDate!.isAfter(_endDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = pickedDate;
          if (_startDate != null && _endDate!.isBefore(_startDate!)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  // 중요도에 따른 색상 반환
  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}