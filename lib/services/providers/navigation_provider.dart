import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int currentIndex = 0;
  void changeIndex(int newIndex) {
    currentIndex = newIndex;
    notifyListeners();
  }
}
