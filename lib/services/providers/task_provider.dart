import 'package:flutter/material.dart';

class TaskProvider with ChangeNotifier {
  int currentDropdownValue = 0;
  late String currentFilter = "all";
  updateFilter(String newValue) {
    currentFilter = newValue;
    notifyListeners();
  }

  updateDropDownValue(int newValue) {
    currentDropdownValue = newValue;
    notifyListeners();
  }
  initValue(){
    currentDropdownValue = 0;
    notifyListeners();
  }
}
