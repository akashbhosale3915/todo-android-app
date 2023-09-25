import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  void getTodos() async {
    final prefs = await SharedPreferences.getInstance();

    todoList = jsonDecode(prefs.getString('todoList')!) ?? [];

    setState(() {
      todoList;
    });
    // print(prefs.getString('todoList'));
  }

  TextEditingController todoController = TextEditingController();
  TextEditingController editController = TextEditingController();
  List<dynamic> todoList = [];
  String todo = '';

  void addTodo() async {
    final prefs = await SharedPreferences.getInstance();
    todo = todoController.text;
    if (todo.isNotEmpty) {
      final newTodo = {
        'title': todo,
        'completed': false,
        'id': todoList.length + 1
      };
      todoList.add(newTodo);
      setState(() {
        todoList;
        prefs.setString('todoList', jsonEncode(todoList));
      });
    }
    todoController.clear();
  }

  void deleteTodo(int index) async {
    final prefs = await SharedPreferences.getInstance();
    showDialogBox(
        'Delete Todo',
        [
          ElevatedButton(
            onPressed: () {
              todoList.removeAt(index);
              setState(() {
                todoList;
                prefs.setString('todoList', jsonEncode(todoList));
              });
              Navigator.pop(context);
            },
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
            child: const Text(
              'No',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        const Text('Are you sure you want to delete ?'));
  }

  void modifyTodo(int index, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      todoList[index]['completed'] = value;
      prefs.setString('todoList', jsonEncode(todoList));
    });
  }

  void editTodo(int index) async {
    final prefs = await SharedPreferences.getInstance();
    editController.text = todoList[index]['title'];
    showDialogBox(
        'Edit todo',
        [
          ElevatedButton(
            onPressed: () {
              setState(() {
                todoList[index]['title'] = editController.text;
                prefs.setString('todoList', jsonEncode(todoList));
              });
              Navigator.pop(context);
            },
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
            child: const Text(
              'Edit',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        TextField(
          autofocus: true,
          controller: editController,
        ));
  }

  void showDialogBox(String title, List<Widget> actions, Widget content) {
    showAdaptiveDialog(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(20),
          elevation: 0,
          title: Text(title),
          content: content,
          actions: actions,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                  autofocus: false,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  controller: todoController,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(204, 255, 193, 7),
                              width: 2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          )),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(204, 255, 193, 7),
                              width: 2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          )),
                      suffixIcon: GestureDetector(
                        onTap: () => todoController.clear(),
                        child: const Icon(
                          Icons.close,
                          color: Color.fromARGB(204, 255, 193, 7),
                        ),
                      ),
                      hintText: 'Add a todo',
                      border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(204, 255, 193, 7)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ))),
            ),
            const SizedBox(
              width: 10,
            ),
            Ink(
              decoration: const ShapeDecoration(
                  shape: CircleBorder(),
                  color: Color.fromARGB(204, 255, 193, 7)),
              child: IconButton(
                onPressed: addTodo,
                iconSize: 40,
                icon: const Icon(Icons.add),
                color: Colors.white,
                splashColor: const Color.fromARGB(204, 255, 193, 7),
                splashRadius: 30,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Expanded(
            child: Container(
          decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(color: Color.fromARGB(255, 211, 211, 211)))),
          child: ListView.builder(
            itemBuilder: (context, index) => ListTile(
              dense: true,
              onTap: () {
                showAdaptiveDialog(
                  useSafeArea: true,
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      titlePadding: EdgeInsets.zero,
                      insetPadding: const EdgeInsets.all(20),
                      elevation: 0,
                      title: const Text(
                        '',
                        style: TextStyle(fontSize: 0),
                      ),
                      content: Text(
                        todoList[index]['title'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  },
                );
              },
              contentPadding: const EdgeInsets.all(0),
              leading: Checkbox(
                  activeColor: Colors.green,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  value: todoList[index]['completed'],
                  onChanged: (bool? value) => modifyTodo(index, value!)),
              title: Text(todoList[index]['title'],
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 18,
                      fontWeight: todoList[index]['completed'] == true
                          ? FontWeight.bold
                          : FontWeight.w400,
                      decoration: todoList[index]['completed'] == true
                          ? TextDecoration.lineThrough
                          : null)),
              trailing: SizedBox(
                width: 60,
                child: Row(children: [
                  GestureDetector(
                    child: const Icon(Icons.edit),
                    onTap: () => editTodo(index),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    child: const Icon(Icons.delete,
                        color: Color.fromARGB(255, 220, 113, 113)),
                    onTap: () => deleteTodo(index),
                  ),
                ]),
              ),
            ),
            itemCount: todoList.length,
          ),
        ))
      ]),
    );
  }
}
