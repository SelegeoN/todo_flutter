import 'package:flutter/material.dart';
import 'package:flutter_todo_1/widgets/group_form/group_form_widget.dart';
import 'package:flutter_todo_1/widgets/groups/groups_widget.dart';
import 'package:flutter_todo_1/widgets/task_form/task_form_widget.dart';
import 'package:flutter_todo_1/widgets/tasks/tasks_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo',
      routes: {
        '/groups': (context) => const GroupsWidget(),
        '/groups/form': (context) => const GroupFormWidget(),
        '/groups/tasks': (context) => const TaskWidget(),
        '/groups/tasks/form': (context) => const TaskFormWidget(),
      },
      initialRoute: '/groups',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
