import 'package:flutter/material.dart';
import 'package:todo/add_task.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> todoList = [];
  void addTodo({required String todoText}) {
    setState(() {
      todoList.insert(0, todoText);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: Text("Drawer"),
      ),
      appBar: AppBar(
        title: const Text("To-Do App"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: SizedBox(
                          height: 300,
                          child: AddTask(
                            addTodo: addTodo,
                          ),
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                todoList.removeAt(index);
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("Task done!")),
                      );
                    });
              },
              title: Text(todoList[index]),
            );
          }),
    );
  }
}
