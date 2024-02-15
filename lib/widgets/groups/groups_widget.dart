import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todo_1/widgets/groups/groups_widget_model.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({super.key});

  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final _model = GroupsWidgetModel();
  @override
  Widget build(BuildContext context) {
    return GroupWidgetModelProvider(_model, child: const _GroupsWidgetBody());
  }
}

class _GroupsWidgetBody extends StatelessWidget {
  const _GroupsWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "а ну делай",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      body: const _GroupListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            GroupWidgetModelProvider.read(context)?.model.showForm(context),
        child: const Icon(Icons.add_box_rounded),
      ),
    );
  }
}

class _GroupListWidget extends StatelessWidget {
  const _GroupListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        GroupWidgetModelProvider.watch(context)?.model.groups.length ?? 0;
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _GroupListRowWidget(
            indexInList: index,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 1);
        },
        itemCount: groupsCount);
  }
}

class _GroupListRowWidget extends StatelessWidget {
  final int indexInList;
  const _GroupListRowWidget({super.key, required this.indexInList});

  void deleteGroup(BuildContext context) {
    final model = GroupWidgetModelProvider.read(context)!.model;
    model.deleteGroup(indexInList);
  }

  @override
  Widget build(BuildContext context) {
    final model = GroupWidgetModelProvider.read(context)!.model;
    final group = model.groups[indexInList];
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: deleteGroup,
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
        onTap: () => model.showTasks(context, indexInList),
        title: Text(group.name),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
