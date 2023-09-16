import 'package:flutter/material.dart';
import 'package:todo/todo_list.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.amber,
            centerTitle: true,
            title: const Text(
              'Todo list',
            ),
          ),
          body: const TodoList()),
    );
  }
}
