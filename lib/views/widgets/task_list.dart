import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/models/task.dart';
import 'package:task_management/views/widgets/task_tile.dart';
class TaskList extends StatelessWidget {
  final List<Task> tasks;
  const TaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left: 13.w, right: 13.w, top: 5.h),
      child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (_, index){
            return TaskTile(task: tasks[index]);
          }),
    );
  }
}
