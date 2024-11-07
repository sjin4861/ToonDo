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
    } else {
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
      backgroundColor: Colors.white, // 전체 배경색 설정
      appBar: AppBar(
        backgroundColor: Color(0xFFF1F1F1),
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF535353)),
              onPressed: () {
                Navigator.pop(context); // 이전 페이지로 이동
              },
            ),
            SizedBox(width: 8),
            Text(
              widget.todo != null
                  ? '투두 수정'
                  : (widget.isDDayTodo ? '디데이 투두 작성' : '데일리 투두 작성'),
              style: TextStyle(
                color: Color(0xFF535353),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.24,
                fontFamily: 'Pretendard Variable',
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
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
                style: TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.15,
                  fontFamily: 'Pretendard Variable',
                ),
              ),
              SizedBox(height: 4),
              Container(
                height: 49,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: ShapeDecoration(
                  color: Color(0xFFF1F1F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: TextFormField(
                  controller: _titleController,
                  maxLength: 20,
                  decoration: InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    hintText: '투두의 이름을 입력하세요.',
                    hintStyle: TextStyle(
                      color: Color(0xFFB2B2B2),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.21,
                      fontFamily: 'Pretendard Variable',
                    ),
                  ),
                  style: TextStyle(
                    color: Color(0xFF111111),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.21,
                    fontFamily: 'Pretendard Variable',
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
              SizedBox(height: 22),
              // 목표 선택
              Text(
                '목표',
                style: TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.15,
                  fontFamily: 'Pretendard Variable',
                ),
              ),
              SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showGoalDropdown = !_showGoalDropdown;
                  });
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFFDAEBCB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedGoalId != null
                              ? goalProvider.goals
                                  .firstWhere((goal) => goal.id == _selectedGoalId)
                                  .name
                              : '목표를 선택하세요.',
                          style: TextStyle(
                            color: Color(0xFF111111),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.18,
                            fontFamily: 'Pretendard Variable',
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.black),
                    ],
                  ),
                ),
              ),
              // 목표 드롭다운 리스트
              if (_showGoalDropdown)
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFDAEBCB),
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
              SizedBox(height: 22),
              // 시작일 및 마감일
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '시작일',
                          style: TextStyle(
                            color: Color(0xFF111111),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.15,
                            fontFamily: 'Pretendard Variable',
                          ),
                        ),
                        SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => _selectDate(isStartDate: true),
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: ShapeDecoration(
                              color: Color(0xFFF1F1F1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _startDate != null
                                    ? _dateFormat.format(_startDate!)
                                    : '시작일을 선택하세요.',
                                style: TextStyle(
                                  color: Color(0xFF111111),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.18,
                                  fontFamily: 'Pretendard Variable',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '마감일',
                          style: TextStyle(
                            color: Color(0xFF111111),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.15,
                            fontFamily: 'Pretendard Variable',
                          ),
                        ),
                        SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => _selectDate(isStartDate: false),
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: ShapeDecoration(
                              color: Color(0xFFF1F1F1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _endDate != null
                                    ? _dateFormat.format(_endDate!)
                                    : '마감일을 선택하세요.',
                                style: TextStyle(
                                  color: Color(0xFF111111),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.18,
                                  fontFamily: 'Pretendard Variable',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // 데일리 투두 설정
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '데일리 투두로 설정',
                    style: TextStyle(
                      color: Color(0xFF111111),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.18,
                      fontFamily: 'Pretendard Variable',
                    ),
                  ),
                  SizedBox(width: 8),
                  Checkbox(
                    value: _isDailyTodo,
                    onChanged: (value) {
                      setState(() {
                        _isDailyTodo = value!;
                        if (_isDailyTodo) {
                          DateTime today = DateTime.now();
                          _startDate = DateTime(today.year, today.month, today.day);
                          _endDate = DateTime(today.year, today.month, today.day);
                        } else {
                          _startDate = null;
                          _endDate = null;
                        }
                      });
                    },
                    activeColor: Color(0xFF78B545),
                  ),
                ],
              ),
              SizedBox(height: 22),
              // 중요도 선택
              Center(
                child: Column(
                  children: [
                    Text(
                      '중요도',
                      style: TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.15,
                        fontFamily: 'Pretendard Variable',
                      ),
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
                            color: _priority >= starIndex
                                ? _getPriorityColor(starIndex)
                                : Colors.grey,
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
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // 투두 생성 또는 업데이트
                      Todo newTodo = Todo(
                        id: widget.todo?.id, // 기존 투두의 ID 유지
                        title: _title,
                        startDate:
                            _isDailyTodo ? DateTime.now() : _startDate ?? DateTime.now(),
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
                  child: Container(
                    width: 326,
                    height: 56,
                    padding: EdgeInsets.symmetric(vertical: 17),
                    decoration: ShapeDecoration(
                      color: Color(0xFF78B545),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.todo != null ? '수정하기' : '작성하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                          fontFamily: 'Pretendard Variable',
                        ),
                      ),
                    ),
                  ),
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
          color: Color(0x4CDAEBCB),
          border: Border(
            bottom: BorderSide(color: Colors.black.withOpacity(0.5), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                goalName,
                style: TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.18,
                  fontFamily: 'Pretendard Variable',
                ),
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