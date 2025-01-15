import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_management/enum/task_priority.dart';
import 'package:task_management/enum/task_state.dart';

class Task {
  final String id;
  final String name;
  final String description;
  final Timestamp date;
  final Timestamp createdAt;
  final TasksState state;
  final String idUser;
  final TaskPriority priority;
  const Task(
      {required this.id,
      required this.name,
      required this.description,
      required this.date,
      required this.state,
      required this.idUser,
      required this.createdAt,
      required this.priority});
  factory Task.fromJson(Map<String, dynamic> data) {
    return Task(
        id: data["id"],
        name: data["name"],
        description: data["description"],
        date: data['date'],
        state: getState(data['state']),
        idUser: data["idUser"],
        createdAt: data['createdAt'],
        priority: getPriority(data["priority"]));
  }
}

TasksState getState(int value) {
  switch (value) {
    case 1:
      return TasksState.DONE;
    case 2:
      return TasksState.ON_PROGRESS;
  }

  return TasksState.TO_DO;
}

TaskPriority getPriority(int value) {
  switch (value) {
    case 1:
      return TaskPriority.HIGH;
    case 2:
      return TaskPriority.MEDIUM;
  }
  return TaskPriority.LOW;
}
