

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/task.dart';

class TasksStreamBuilder extends StatefulWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> stream;
  final Widget Function(List<Task>) builder;

  const TasksStreamBuilder(
      {super.key, required this.stream, required this.builder});

  @override
  State<TasksStreamBuilder> createState() => _TasksStreamBuilderState();
}

class _TasksStreamBuilderState extends State<TasksStreamBuilder> {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: widget.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor));
        }

        // Puis vérifier les données
        if (!snapshot.hasData ||
            snapshot.data == null) {
          return const Center(
            child:
            Text("Aucune tache trouvée!", style: TextStyle(fontSize: 18, color: Colors.white)),
          );
        }

        if (snapshot.hasError) {
          debugPrint('Stream Error: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var docs = snapshot.data;
        List<Task> allTasks = docs!.docs.map((doc) {
          final data = doc.data();
          return Task.fromJson(data);
        }).toList();
        if (allTasks.isEmpty) {
          return const Center(
            child:

            Text("Aucune tache trouvée!", style: TextStyle(fontSize: 18,color: Colors.white)),
          );
        }
        return widget.builder(allTasks);
      },
    );
  }
}
