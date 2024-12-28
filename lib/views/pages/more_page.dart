import 'package:flutter/material.dart';

import '../../controllers/color_controller.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorController().colorSixth,
      body: Center(
        child: Text(
          'More Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
