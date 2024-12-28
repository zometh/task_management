import 'package:flutter/material.dart';

import '../../controllers/color_controller.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorController().colorSixth,
      body: Center(
        child: Text(
          'Search Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
