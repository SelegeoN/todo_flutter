import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todo_1/widgets/tasks/tasks_widget_model.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({super.key});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TasksWidgetModel? _model;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_model == null) {
      final groupKey = ModalRoute.of(context)!.settings.arguments as int;
      _model = TasksWidgetModel(groupKey: groupKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = _model;
    if (model != null) {
      return TasksWidgetModelProvider(model, child: const _TasksWidgetBody());
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

class _TasksWidgetBody extends StatelessWidget {
  const _TasksWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.watch(context)?.model;
    final title = model?.group?.name ?? 'ОО А Я И НЕ ДУМАЛ';
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      body: const _TaskListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.showForm(context),
        child: const Icon(Icons.add_box_rounded),
      ),
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  const _TaskListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tasksCount =
        TasksWidgetModelProvider.watch(context)?.model.tasks.length ?? 0;
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _TaskListRowWidget(
            indexInList: index,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 1);
        },
        itemCount: tasksCount);
  }
}

class _TaskListRowWidget extends StatelessWidget {
  final int indexInList;
  const _TaskListRowWidget({super.key, required this.indexInList});

  void deleteTask(BuildContext context) {
    final model = TasksWidgetModelProvider.read(context)!.model;
    model.deleteTask(indexInList);
  }

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.read(context)!.model;
    final task = model.tasks[indexInList];

    final icon = task.isDone
        ? Icons.check_box_rounded
        : Icons.check_box_outline_blank_rounded;
    final textStyle = task.isDone
        ? const TextStyle(decoration: TextDecoration.lineThrough)
        : null;

    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: deleteTask,
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Удалить',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: ListTile(
        onTap: () => model.doneToggle(indexInList),
        title: Text(
          task.text,
          style: textStyle,
        ),
        trailing: Icon(icon),
      ),
    );
  }
}
