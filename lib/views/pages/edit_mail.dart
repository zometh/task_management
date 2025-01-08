import 'package:flutter/material.dart';
import 'package:task_management/models/user_mine.dart';
import 'package:task_management/views/pages/custom_appbar.dart';

class EditMailPage extends StatefulWidget {
  final UserMine userMine;
  const EditMailPage({super.key, required this.userMine});

  @override
  State<EditMailPage> createState() => _EditMailPageState();
}

class _EditMailPageState extends State<EditMailPage> {
  UserMine get user => widget.userMine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: "Modifier adresse email"),
    );
  }
}
