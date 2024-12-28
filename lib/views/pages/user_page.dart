import 'package:flutter/material.dart';

import '../../controllers/color_controller.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorController().colorSixth,
      body: Center(
        child: Text(
          'User Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
