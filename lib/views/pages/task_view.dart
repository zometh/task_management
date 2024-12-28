import 'package:flutter/material.dart';

class AllTaskPage extends StatelessWidget {
  const AllTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Toutes les taches",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class TasksDonePage extends StatelessWidget {
  const TasksDonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Taches terminées", style: TextStyle(color: Colors.white)),
    );
  }
}

class TasksTodoPage extends StatelessWidget {
  const TasksTodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Taches à faire", style: TextStyle(color: Colors.white)),
    );
  }
}

class TasksOnProgressPage extends StatelessWidget {
  const TasksOnProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Taches en cours", style: TextStyle(color: Colors.white)),
    );
  }
}
