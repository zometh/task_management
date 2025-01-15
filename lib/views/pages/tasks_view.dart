import 'package:flutter/material.dart';
import 'package:task_management/services/data/get_user_datas.dart';
import 'package:task_management/views/widgets/task_list.dart';

import '../widgets/streams.dart';

class AllTaskPage extends StatefulWidget {
  const AllTaskPage({super.key});

  @override
  State<AllTaskPage> createState() => _AllTaskPageState();
}

class _AllTaskPageState extends State<AllTaskPage> {
  final GlobalKey<AnimatedListState> key = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return TasksStreamBuilder(
        stream: GetUserDatas().getAllTasks(),
        builder: (tasks) => TaskList(tasks: tasks));
  }
}

class TasksDonePage extends StatelessWidget {
  const TasksDonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return TasksStreamBuilder(
        stream: GetUserDatas().getDoneTasks(),
        builder: (tasks) => TaskList(tasks: tasks));
  }
}

class TasksTodoPage extends StatelessWidget {
  const TasksTodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TasksStreamBuilder(
        stream: GetUserDatas().getTodoTasks(),
        builder: (tasks) => TaskList(tasks: tasks));
  }
}

class TasksOnProgressPage extends StatelessWidget {
  const TasksOnProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TasksStreamBuilder(
        stream: GetUserDatas().getOnprogressTasks(),
        builder: (tasks) => TaskList(tasks: tasks));
  }
}
