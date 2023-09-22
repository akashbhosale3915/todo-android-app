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
    todoList.removeAt(index);
    setState(() {
      todoList;
      prefs.setString('todoList', jsonEncode(todoList));
    });
  }

  void modifyTodo(int index, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      todoList[index]['completed'] = value;
      prefs.setString('todoList', jsonEncode(todoList));
    });
  }

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  controller: todoController,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber, width: 2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          )),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber, width: 2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          )),
                      suffixIcon: GestureDetector(
                        onTap: () => todoController.clear(),
                        child: const Icon(
                          Icons.close,
                          color: Colors.amber,
                        ),
                      ),
                      hintText: 'Add a todo',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
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
                  shape: CircleBorder(), color: Colors.amber),
              child: IconButton(
                onPressed: addTodo,
                iconSize: 40,
                icon: const Icon(Icons.add),
                color: Colors.white,
                splashColor: Colors.amberAccent,
                splashRadius: 30,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
            child: ListView.builder(
          itemBuilder: (context, index) => ListTile(
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
                    fontWeight: FontWeight.bold,
                    decoration: todoList[index]['completed'] == true
                        ? TextDecoration.lineThrough
                        : null)),
            trailing: GestureDetector(
              child: const Icon(Icons.delete, color: Colors.red),
              onTap: () => deleteTodo(index),
            ),
          ),
          itemCount: todoList.length,
        ))
      ]),
    );
  }
}
