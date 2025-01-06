import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_management/controllers/color_controller.dart';
import 'package:task_management/views/pages/home_page.dart';
import 'package:task_management/views/pages/login_page.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorController().colorFour,
              ),
            );
          }
          if (!snapshots.hasData) {
            return const LoginPage();
          }
          return const HomePage();
        });
  }
}
