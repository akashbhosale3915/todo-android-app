import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/theme_provider.dart';
import 'package:todo/todo_list.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Poppins',
          brightness: Provider.of<ThemeProvider>(context).currentTheme ==
                  ThemeData.dark(useMaterial3: true)
              ? Brightness.dark
              : Brightness.light,
        ),
        home: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                  icon: Provider.of<ThemeProvider>(context).currentTheme ==
                          ThemeData.dark(useMaterial3: true)
                      ? const Icon(Icons.light_mode)
                      : const Icon(Icons.dark_mode),
                )
              ],
              elevation: 0,
              backgroundColor: const Color.fromARGB(204, 255, 193, 7),
              centerTitle: true,
              title: const Text(
                'Todo list',
              ),
            ),
            body: const TodoList()));
  }
}
