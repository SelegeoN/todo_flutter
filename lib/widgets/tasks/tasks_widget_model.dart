import 'package:flutter/material.dart';
import 'package:flutter_todo_1/domain/entity/task.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_todo_1/domain/entity/group.dart';

class TasksWidgetModel extends ChangeNotifier {
  int groupKey;
  late final Future<Box<Group>> _groupBox;
  var _tasks = <Task>[];
  List<Task> get tasks => _tasks.toList();
  Group? _group;
  Group? get group => _group;
  TasksWidgetModel({
    required this.groupKey,
  }) {
    _setup();
  }

  void _loadGroup() async {
    final box = await _groupBox;
    _group = box.get(groupKey);
    notifyListeners();
  }

  void _readTasks() {
    _tasks = _group?.tasks ?? <Task>[];
    notifyListeners();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed('/groups/tasks/form', arguments: groupKey);
  }

  void _setupListenTasks() async {
    final box = await _groupBox;
    _readTasks();
    box.listenable(keys: <dynamic>[groupKey]).addListener(_readTasks);
  }

  void _setup() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    _groupBox = Hive.openBox<Group>('groups_box');
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    Hive.openBox<Task>('tasks_box');
    _loadGroup();
    _setupListenTasks();
  }

  void deleteTask(int groupInd) async {
    await _group?.tasks?.deleteFromHive(groupInd);
    _group?.save();
  }

  void doneToggle(int groupInd) async {
    final task = _group?.tasks?[groupInd];
    final currentState = task?.isDone ?? false;
    task?.isDone = !currentState;
    await task?.save();
    notifyListeners();
  }
}

class TasksWidgetModelProvider extends InheritedNotifier {
  final TasksWidgetModel model;

  const TasksWidgetModelProvider(this.model, {Key? key, required Widget child})
      : super(key: key, notifier: model, child: child);

  static TasksWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
  }

  static TasksWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TasksWidgetModelProvider>()
        ?.widget;
    return widget is TasksWidgetModelProvider ? widget : null;
  }
}
