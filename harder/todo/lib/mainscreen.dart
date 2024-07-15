import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/add_task.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> todoList = [];

  void addTodo({required String todoText}) {
    if (todoList.contains(todoText)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Already exists"),
            content: const Text("This task is already exists."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("close"))
            ],
          );
        },
      );
      return;
    }
    setState(() {
      todoList.insert(0, todoText);
    });
    writeLocalData();
    Navigator.pop(context);
  }

  void writeLocalData() async {
// Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todoList', todoList);
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      todoList = (prefs.getStringList('todoList') ?? []).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/chim.png'),
              backgroundColor: Colors.white,
            ),
            otherAccountsPictures: const [
              CircleAvatar(backgroundImage: AssetImage('assets/cat.png')),
              //CircleAvatar(backgroundImage: AssetImage('assets/cat.png')),
            ],
            accountName: const Text(
              'Chim-chak man',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: const Text('ccm@naver.com'),
            onDetailsPressed: () {
              debugPrint('arrow is clicked');
            },
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 127, 212, 246),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0))),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.grey[850],
            ),
            title: const Text('HOME'),
            onTap: () {
              debugPrint('Home is clicked');
            },
            trailing: const Icon(Icons.add),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.grey[850],
            ),
            title: const Text('Settings'),
            onTap: () {
              debugPrint('settings is clicked');
            },
            trailing: const Icon(Icons.add),
          ),
          ListTile(
            leading: Icon(
              Icons.question_answer,
              color: Colors.grey[850],
            ),
            title: const Text('Q&A'),
            onTap: () {
              debugPrint('Q&A is clicked');
            },
            trailing: const Icon(Icons.add),
          ),
        ],
      )),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 128, 213, 252),
        title: const Text(
          "To-Do App",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: (todoList.isEmpty)
          ? const Center(
              child: Text(
              "No Items on the list",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ))
          : ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    color: Colors.red,
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(Icons.check),
                        ),
                      ],
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      todoList.removeAt(index);
                      writeLocalData();
                    });
                  },
                  child: ListTile(
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
                                    writeLocalData();
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Task done!")),
                            );
                          });
                    },
                    title: Text(todoList[index]),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
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
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
