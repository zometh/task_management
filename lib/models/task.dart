import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:task_management/enum/task_state.dart';

class Task {
  final String id;
  final String name;
  final String description;
  final Timestamp date;
  final TasksState state;
  final String idUser;
  const Task(
      {required this.id,
      required this.name,
      required this.description,
      required this.date,
      required this.state,
      required this.idUser});
  factory Task.fromJson(Map<String, dynamic> data) {
    return Task(
        id: data["id"],
        name: data["name"],
        description: data["description"],
        date: data['date'],
        state: getState(data['state']),
        idUser: data["idUser"]);
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
