import 'package:flutter/material.dart';
import 'package:flutter_todo_1/domain/entity/group.dart';
import 'package:flutter_todo_1/domain/entity/task.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GroupsWidgetModel extends ChangeNotifier {
  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();

  GroupsWidgetModel() {
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed('/groups/form');
  }

  void showTasks(BuildContext context, int groupInd) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('groups_box');
    final groupKey = box.keyAt(groupInd) as int;
    Navigator.of(context).pushNamed('/groups/tasks', arguments: groupKey);
  }

  void deleteGroup(int groupInd) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('groups_box');
    await box.getAt(groupInd)?.tasks?.deleteAllFromHive();
    await box.deleteAt(groupInd);
  }

  void _setup() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    await Hive.openBox<Task>('tasks_box');
    final box = await Hive.openBox<Group>('groups_box');
    _groups = box.values.toList();
    notifyListeners();
    box.listenable().addListener(() {
      _groups = box.values.toList();
      notifyListeners();
    });
  }
}

class GroupWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;

  const GroupWidgetModelProvider(this.model, {Key? key, required Widget child})
      : super(key: key, notifier: model, child: child);

  static GroupWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupWidgetModelProvider>();
  }

  static GroupWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupWidgetModelProvider>()
        ?.widget;
    return widget is GroupWidgetModelProvider ? widget : null;
  }
}
