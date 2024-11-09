import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG 아이콘 사용을 위해 추가
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/providers/goal_provider.dart';
import 'package:todo_with_alarm/providers/todo_provider.dart';
import 'package:todo_with_alarm/widgets/calendar_bottom_sheet.dart';

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
  int _eisenhowerType = 0; // 아이젠하워 매트릭스 타입 (0~3)
  int _importance = 0;
  int _urgency = 0;
  final _titleController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('yyyy년 M월 d일');

  bool _showGoalDropdown = false; // 목표 드롭다운 표시 여부
  bool _isTitleNotEmpty = false; // 투두 이름 입력 여부

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      // 수정 모드
      _titleController.text = widget.todo!.title;
      _isTitleNotEmpty = _titleController.text.isNotEmpty; // 여기서 초기화
      _selectedGoalId = widget.todo!.goalId;
      _startDate = widget.todo!.startDate;
      _endDate = widget.todo!.endDate;
      _eisenhowerType = widget.todo!.importance.toInt();
      _isDailyTodo = widget.todo!.startDate == widget.todo!.endDate;
      // 중요도와 긴급도 설정
      switch (_eisenhowerType) {
        case 0:
          _importance = 0;
          _urgency = 0;
          break;
        case 1:
          _importance = 0;
          _urgency = 1;
          break;
        case 2:
          _importance = 1;
          _urgency = 0;
          break;
        case 3:
          _importance = 1;
          _urgency = 1;
          break;
      }
    } else {
      // 새로 추가 모드
      _isDailyTodo = !widget.isDDayTodo;
      if (_isDailyTodo) {
        _startDate = null;
        _endDate = null;
      }
    }
    _titleController.addListener(_onTitleChanged);
  }

  void _onTitleChanged() {
    setState(() {
      _isTitleNotEmpty = _titleController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC),
      appBar: AppBar(
        backgroundColor: Color(0xFFFCFCFC),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF1C1D1B)),
          onPressed: () {
            Navigator.pop(context); // 이전 페이지로 이동
          },
        ),
        title: Text(
          widget.todo != null ? '투두 수정' : '투두 작성',
          style: TextStyle(
            color: Color(0xFF1C1D1B),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.24,
            fontFamily: 'Pretendard Variable',
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: Container(
            color: Color(0x3F1C1D1B),
            height: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 16),
                // 디데이/데일리 토글 버튼
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isDailyTodo = false; // D-Day 선택
                            _startDate = DateTime.now();
                            _endDate = DateTime.now().add(Duration(days: 1));
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          decoration: ShapeDecoration(
                            color: !_isDailyTodo ? Color(0xFF78B545) : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Color(0xFF78B545)),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                              ),
                            ),
                          ),
                          child: Text(
                            '디데이',
                            style: TextStyle(
                              color: !_isDailyTodo ? Colors.white : Color(0xFF1C1D1B),
                              fontSize: 10,
                              fontFamily: 'Pretendard Variable',
                              fontWeight: !_isDailyTodo ? FontWeight.w700 : FontWeight.w400,
                              letterSpacing: 0.15,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isDailyTodo = true; // 데일리 선택
                            _startDate = null;
                            _endDate = null;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          decoration: ShapeDecoration(
                            color: _isDailyTodo ? Color(0xFF78B545) : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Color(0xFF78B545)),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(4),
                                bottomRight: Radius.circular(4),
                              ),
                            ),
                          ),
                          child: Text(
                            '데일리',
                            style: TextStyle(
                              color: _isDailyTodo ? Colors.white : Color(0xFF1C1D1B),
                              fontSize: 10,
                              fontFamily: 'Pretendard Variable',
                              fontWeight: _isDailyTodo ? FontWeight.w700 : FontWeight.w400,
                              letterSpacing: 0.15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                // 투두 이름
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '투두 이름',
                    style: TextStyle(
                      color: Color(0xFF1C1D1B),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.15,
                      fontFamily: 'Pretendard Variable',
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: _isTitleNotEmpty ? Color(0xFF78B545) : Color(0xFFDDDDDD),
                      ),
                      borderRadius: BorderRadius.circular(8),
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
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.18,
                        fontFamily: 'Pretendard Variable',
                      ),
                    ),
                    style: TextStyle(
                      color: Color(0xFF1C1D1B),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.18,
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
                SizedBox(height: 24),
                // 목표 선택
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '목표',
                    style: TextStyle(
                      color: Color(0xFF1C1D1B),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.15,
                      fontFamily: 'Pretendard Variable',
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        width: 1,
                        color: _selectedGoalId != null ? Color(0xFF78B545) : Color(0xFFDDDDDD),
                      ),
                    ),
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
                            color: Color(0xFF1C1D1B),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.18,
                            fontFamily: 'Pretendard Variable',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showGoalDropdown = !_showGoalDropdown;
                          });
                        },
                        child: Icon(
                          _showGoalDropdown ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          color: Color(0xFF1C1D1B),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_showGoalDropdown)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFFDDDDDD)),
                    ),
                    child: Column(
                      children: [
                        _buildGoalItem('목표 미설정', null, isSelected: _selectedGoalId == null),
                        ...goalProvider.goals.map((goal) {
                          return _buildGoalItem(goal.name, goal.id,
                              isSelected: _selectedGoalId == goal.id);
                        }).toList(),
                      ],
                    ),
                  ),
                SizedBox(height: 24),
                // 시작일 및 마감일 (데일리 투두가 아닐 때만 표시)
                if (!_isDailyTodo)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '시작일',
                              style: TextStyle(
                                color: Color(0xFF1C1D1B),
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.15,
                                fontFamily: 'Pretendard Variable',
                              ),
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _selectDate(isStartDate: true),
                              child: Container(
                                height: 32,
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1, color: Color(0xFFDDDDDD)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 15, color: Color(0xFFDDDDDD)),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _startDate != null
                                            ? _dateFormat.format(_startDate!)
                                            : '시작일을 선택하세요',
                                        style: TextStyle(
                                          color: _startDate != null
                                              ? Color(0xFF1C1D1B)
                                              : Color(0x3F1C1D1B),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.15,
                                          fontFamily: 'Pretendard Variable',
                                        ),
                                      ),
                                    ),
                                  ],
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
                                color: Color(0xFF1C1D1B),
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.15,
                                fontFamily: 'Pretendard Variable',
                              ),
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _selectDate(isStartDate: false),
                              child: Container(
                                height: 32,
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1, color: Color(0xFFDDDDDD)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 15, color: Color(0xFFDDDDDD)),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _endDate != null
                                            ? _dateFormat.format(_endDate!)
                                            : '마감일을 선택하세요',
                                        style: TextStyle(
                                          color: _endDate != null
                                              ? Color(0xFF1C1D1B)
                                              : Color(0x3F1C1D1B),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.15,
                                          fontFamily: 'Pretendard Variable',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 24),
                // 아이젠하워 매트릭스 선택
                Column(
                  children: [
                    Text(
                      '아이젠하워',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF1C1D1B),
                        fontSize: 10,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.15,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(4, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _eisenhowerType = index;
                              switch (index) {
                                case 0:
                                  _importance = 0;
                                  _urgency = 0;
                                  break;
                                case 1:
                                  _importance = 0;
                                  _urgency = 1;
                                  break;
                                case 2:
                                  _importance = 1;
                                  _urgency = 0;
                                  break;
                                case 3:
                                  _importance = 1;
                                  _urgency = 1;
                                  break;
                              }
                            });
                          },
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/face$index.svg',
                                width: 32,
                                height: 32,
                                colorFilter: ColorFilter.mode(
                                  _getEisenhowerColor(index, _eisenhowerType == index),
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _getEisenhowerLabel(index),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _getEisenhowerColor(index, _eisenhowerType == index),
                                  fontSize: 8,
                                  fontFamily: 'Pretendard Variable',
                                  fontWeight: _eisenhowerType == index
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  letterSpacing: 0.12,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                // 작성하기/수정하기 버튼
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // 투두 생성 또는 업데이트
                      Todo newTodo = Todo(
                        id: widget.todo?.id, // 기존 투두의 ID 유지
                        title: _title,
                        startDate: _isDailyTodo ? DateTime.now() : (_startDate ?? DateTime.now()),
                        endDate: _isDailyTodo ? DateTime.now() : (_endDate ?? DateTime.now()),
                        goalId: _selectedGoalId,
                        importance: _eisenhowerType.toDouble(), // 아이젠하워 타입 저장
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
                    width: double.infinity,
                    height: 56,
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    padding: EdgeInsets.symmetric(vertical: 16),
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
                          fontSize: 16,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.24,
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
      ),
    );
  }

  // 목표 아이템 위젯 생성
  Widget _buildGoalItem(String goalName, String? goalId, {required bool isSelected}) {
    return GestureDetector(
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
          color: isSelected ? Color(0xFFE4F0D9) : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: Color(0xFFDDDDDD), width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: ShapeDecoration(
                color: isSelected ? Color(0x7FAED28F) : Color(0x7FDDDDDD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(Icons.flag, size: 16, color: Colors.white),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                goalName,
                style: TextStyle(
                  color: Color(0xFF1C1D1B),
                  fontSize: 12,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 날짜 선택 메서드
  void _selectDate({required bool isStartDate}) async {
    DateTime initialDate = DateTime.now();
    if (isStartDate && _startDate != null) {
      initialDate = _startDate!;
    } else if (!isStartDate && _endDate != null) {
      initialDate = _endDate!;
    }

    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
      builder: (context) => SelectDateBottomSheet(initialDate: initialDate),
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

  // 아이젠하워 매트릭스 라벨 반환 메서드
  String _getEisenhowerLabel(int index) {
    switch (index) {
      case 0:
        return '중요하거나\n급하지 않아';
      case 1:
        return '중요하지만\n급하지는 않아';
      case 2:
        return '급하지만\n중요하지는 않아';
      case 3:
        return '중요하고\n급한일이야!';
      default:
        return '';
    }
  }

  // 아이젠하워 매트릭스 색상 반환 메서드
  Color _getEisenhowerColor(int index, bool isSelected) {
    if (!isSelected) {
      return Color(0x7F1C1D1B);
    }
    switch (index) {
      case 0:
        return Colors.black;
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}