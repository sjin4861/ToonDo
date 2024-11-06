import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/providers/goal_provider.dart';
import 'package:todo_with_alarm/providers/todo_provider.dart';

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
  final DateFormat _dateFormat = DateFormat('yyyy년 M월 d일');

  bool _showGoalDropdown = false; // 목표 드롭다운 표시 여부

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
    else {
      // 새로 추가 모드
      _isDailyTodo = !widget.isDDayTodo; // isDDayTodo가 false이면 데일리 투두이므로, _isDailyTodo를 true로 설정
      if (_isDailyTodo) {
        // 데일리 투두인 경우 시작일과 마감일을 오늘로 설정
        DateTime today = DateTime.now();
        _startDate = DateTime(today.year, today.month, today.day);
        _endDate = DateTime(today.year, today.month, today.day);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.todo != null
              ? '투두 수정'
              : (widget.isDDayTodo ? '디데이 투두 작성' : '데일리 투두 작성'),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 이전 페이지로 이동
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 24),
              // 투두 이름
              Text(
                '투두 이름',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                child: TextFormField(
                  controller: _titleController,
                  maxLength: 20,
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: InputBorder.none,
                    hintText: '투두의 이름을 입력하세요.',
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
              ),
              SizedBox(height: 24),
              // 목표 선택
              Text(
                '목표',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showGoalDropdown = !_showGoalDropdown;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    border: Border.all(color: Colors.black.withOpacity(0.5)),
                  ),
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedGoalId != null
                              ? goalProvider.goals
                                  .firstWhere((goal) => goal.id == _selectedGoalId)
                                  .name
                              : '목표를 선택하세요.',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              // 목표 드롭다운 리스트
              if (_showGoalDropdown)
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    border: Border.all(color: Colors.black.withOpacity(0.5)),
                  ),
                  height: 240,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildGoalDropdownItem('목표 미설정', null),
                      ...goalProvider.goals.map((goal) {
                        return _buildGoalDropdownItem(goal.name, goal.id);
                      }).toList(),
                    ],
                  ),
                ),
              SizedBox(height: 24),
              // 시작일 및 마감일
              Text(
                '시작일',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(isStartDate: true),
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _startDate != null
                          ? _dateFormat.format(_startDate!)
                          : '시작일을 선택하세요.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                '마감일',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(isStartDate: false),
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _endDate != null
                          ? _dateFormat.format(_endDate!)
                          : '마감일을 선택하세요.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // 데일리 투두 설정
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '데일리 투두로 설정',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(width: 8),
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
              Center(
                child: Column(
                  children: [
                    Text(
                      '중요도',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        int starIndex = index + 1;
                        return IconButton(
                          iconSize: 40,
                          icon: Icon(
                            Icons.star,
                            color: _priority >= starIndex ? _getPriorityColor(starIndex) : Colors.grey,
                            size: 40,
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
              ),
              SizedBox(height: 24),
              // 작성하기 버튼
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // 투두 생성 또는 업데이트
                      Todo newTodo = Todo(
                        id: widget.todo?.id, // 기존 투두의 ID 유지
                        title: _title,
                        startDate: _isDailyTodo ? DateTime.now() : _startDate ?? DateTime.now(),
                        endDate: _isDailyTodo ? DateTime.now() : _endDate ?? DateTime.now(),
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
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // 목표 드롭다운 아이템 생성
  Widget _buildGoalDropdownItem(String goalName, String? goalId) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedGoalId = goalId;
          _showGoalDropdown = false;
        });
      },
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xFFD9D9D9),
          border: Border(
            bottom: BorderSide(color: Colors.black.withOpacity(0.5), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                goalName,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 날짜 선택 Bottom Sheet
  void _selectDate({required bool isStartDate}) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2020);
    DateTime lastDate = DateTime(2030);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate ?? initialDate : _endDate ?? initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
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