import 'package:flutter/material.dart';
import 'package:domain/entities/goal.dart';
import 'package:domain/entities/todo.dart';
import 'package:get_it/get_it.dart';
import 'package:domain/usecases/goal/get_goals_local.dart';
import 'package:domain/usecases/todo/get_all_todos.dart';
import 'package:domain/entities/status.dart';

class ChatInputBar extends StatefulWidget {
  final bool isSending;
  final Future<void> Function(
      String text, List<Goal> goals, List<Todo> todos) onSend;
  const ChatInputBar({super.key, required this.onSend, required this.isSending});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  final List<Goal> _goals = [];
  final List<Todo> _todos = [];

  /* ────── UI ────── */
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        elevation: 12,
        color: Colors.white.withOpacity(0.95),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // (A) 첨부 Chip 렌더
              if (_goals.isNotEmpty || _todos.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    ..._goals.map((g) => _buildChip(g.name, () {
                          setState(() => _goals.remove(g));
                        })),
                    ..._todos.map((t) => _buildChip(t.title, () {
                          setState(() => _todos.remove(t));
                        })),
                  ],
                ),
              Row(
                children: [
                  // (B) 첨부 버튼
                  IconButton(
                    tooltip: 'Goal / Todo 첨부',
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: _openAttachSheet,
                  ),
                  // (C) 텍스트 필드
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 3,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _submit,
                      decoration: const InputDecoration(
                        hintText: '메시지를 입력하세요',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                  // (D) 전송 버튼
                  IconButton(
                    icon: widget.isSending
                        ? const CircularProgressIndicator(strokeWidth: 2)
                        : const Icon(Icons.send),
                    onPressed:
                        widget.isSending ? null : () => _submit(_controller.text),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* ────── Chip & BottomSheet ────── */
  Widget _buildChip(String label, VoidCallback onDeleted) => Chip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onDeleted,
      );

  void _openAttachSheet() async {
    // 실제 데이터 – 로컬 저장소에서 가져오기
    final goals = await GetIt.I<GetGoalsLocalUseCase>()();
    final todos = await GetIt.I<GetAllTodosUseCase>()();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AttachSheet(
        goals: goals,
        todos: todos,
        selectedGoals: _goals,
        selectedTodos: _todos,
        onConfirm: (selGoals, selTodos) {
          setState(() {
            _goals
              ..clear()
              ..addAll(selGoals);
            _todos
              ..clear()
              ..addAll(selTodos);
          });
        },
      ),
    );
  }

  /* ────── 전송 ────── */
  void _submit(String text) {
    if (text.trim().isEmpty && _goals.isEmpty && _todos.isEmpty) return;
    widget.onSend(text.trim(), List.of(_goals), List.of(_todos));
    _controller.clear();
    setState(() {
      _goals.clear();
      _todos.clear();
    });
  }
}

/* ───────────────────────────────────
   선택 BottomSheet – Goal/Todo Picker
   ─────────────────────────────────── */

// attach sheet 단독 사용 필터 enum
enum _TodoFilter { all, dDay, daily }

class _AttachSheet extends StatefulWidget {
  final List<Goal> goals;
  final List<Todo> todos;
  final List<Goal> selectedGoals;
  final List<Todo> selectedTodos;
  final void Function(List<Goal>, List<Todo>) onConfirm;
  const _AttachSheet({
    required this.goals,
    required this.todos,
    required this.selectedGoals,
    required this.selectedTodos,
    required this.onConfirm,
  });

  @override
  State<_AttachSheet> createState() => _AttachSheetState();
}

class _AttachSheetState extends State<_AttachSheet> {
  Status _goalFilter = Status.active;
  _TodoFilter _todoFilter = _TodoFilter.all;
  late final _selGoals = [...widget.selectedGoals];
  late final _selTodos  = [...widget.selectedTodos];

  String _statusLabel(Status s) => s.toString().split('.').last;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('대화에 첨부할 항목', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              // Goal 상태 필터 (active 기본)
              Wrap(
                spacing: 6,
                children: [
                  for (final status in Status.values)
                    ChoiceChip(
                      label: Text(_statusLabel(status)),
                      selected: _goalFilter == status,
                      onSelected: (_) => setState(() => _goalFilter = status),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // 필터 적용된 Goals 리스트
              _buildSection(
                'Goals',
                widget.goals.where((g) => g.status == _goalFilter).toList(),
                _selGoals,
              ),
              const SizedBox(height: 12),
              // Todos 타입 필터
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                children: [
                  ChoiceChip(label: const Text('All'), selected: _todoFilter==_TodoFilter.all, onSelected: (_) => setState(()=> _todoFilter=_TodoFilter.all)),
                  ChoiceChip(label: const Text('D-day'), selected: _todoFilter==_TodoFilter.dDay, onSelected: (_) => setState(()=> _todoFilter=_TodoFilter.dDay)),
                  ChoiceChip(label: const Text('Daily'), selected: _todoFilter==_TodoFilter.daily, onSelected: (_) => setState(()=> _todoFilter=_TodoFilter.daily)),
                ],
              ),
              const SizedBox(height: 12),
              // 필터 적용된 Todos 리스트 (최근 1주일)
              _buildSection(
                'Todos',
                widget.todos.where((t) {
                  final now = DateTime.now();
                  final weekAgo = now.subtract(Duration(days: 7));
                  if (t.endDate.isBefore(weekAgo) || t.startDate.isAfter(now)) return false;
                  switch (_todoFilter) {
                    case _TodoFilter.dDay:
                      return t.isDDayTodo();
                    case _TodoFilter.daily:
                      return !t.isDDayTodo();
                    default:
                      return true;
                  }
                }).toList(),
                _selTodos,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.onConfirm(_selGoals, _selTodos);
                  Navigator.pop(context);
                },
                child: const Text('첨부'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection<T>(String title, List<T> items, List<T> target) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          children: [
            for (final item in items)
              FilterChip(
                label: Text(item is Goal ? item.name : (item as Todo).title),
                selected: target.contains(item),
                onSelected: (sel) {
                  setState(() {
                    sel ? target.add(item) : target.remove(item);
                  });
                },
              )
          ],
        ),
      ],
    );
  }
}