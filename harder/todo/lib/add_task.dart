import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  final void Function({required String todoText}) addTodo;
  const AddTask({super.key, required this.addTodo});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var todoText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text("Add Task"),
        Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
            autofocus: true,
            onSubmitted: (value) {
              if (todoText.text.isNotEmpty) {
                widget.addTodo(todoText: todoText.text);
              }
              todoText.clear();
            },
            controller: todoText,
            decoration: const InputDecoration(hintText: "Add task"),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
          onPressed: () {
            if (todoText.text.isNotEmpty) {
              widget.addTodo(todoText: todoText.text);
            }
            todoText.clear();
          },
          child: const Text(
            "Add",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
