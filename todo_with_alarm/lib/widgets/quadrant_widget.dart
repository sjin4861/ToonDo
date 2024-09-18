// widgets/quadrant_widget.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/utils/color_utils.dart'; // 추가
import 'todo_circle.dart';

class QuadrantWidget extends StatelessWidget {
  final String title;
  final List<Todo> todos;
  final Color color;
  final String quadrant;
  final Function(Todo, String) onMoveTodo;
  final Function(Todo) onShowDetails;

  const QuadrantWidget({
    Key? key,
    required this.title,
    required this.todos,
    required this.color,
    required this.quadrant,
    required this.onMoveTodo,
    required this.onShowDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget<Todo>(
      onWillAccept: (data) => true,
      onAccept: (data) {
        onMoveTodo(data, quadrant);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            border: Border.all(color: color, width: 2.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5.0),
                color: color,
                width: double.infinity,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: todos.isNotEmpty
                    ? GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 내부 정렬을 위해 열 수 조절
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          Todo todo = todos[index];
                          return GestureDetector(
                            onTap: () {
                              onShowDetails(todo);
                            },
                            child: Draggable<Todo>(
                              data: todo,
                              feedback: Material(
                                color: Colors.transparent,
                                child: TodoCircle(todo: todo),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.5,
                                child: TodoCircle(todo: todo),
                              ),
                              child: TodoCircle(todo: todo),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          '할 일이 없습니다.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}