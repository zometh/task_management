import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/services/providers/task_provider.dart';

class TaskPriorityDropdown extends StatefulWidget {
  
  const TaskPriorityDropdown({super.key});

  @override
  State<TaskPriorityDropdown> createState() => _TaskPriorityDropdownState();
}

class _TaskPriorityDropdownState extends State<TaskPriorityDropdown> {
  List<String> options = <String>['Elevée', 'Moyenne', 'Faible'];

  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: true);
    return Container(
      width: 200,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButton<int>(
        value: taskProvider.currentDropdownValue,
        onChanged: (int? value) => taskProvider.updateDropDownValue(value!)
   
          
        ,
        underline: const SizedBox(),
        isExpanded: true,
        style: const TextStyle(color: Colors.black),
        dropdownColor: Colors.white,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
        selectedItemBuilder: (BuildContext context) {
          return options.map((String value) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                options[taskProvider.currentDropdownValue],
              ),
            );
          }).toList();
        },
        items: options.asMap().entries.map((entry) {
          return DropdownMenuItem<int>(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
      ),
    );
  }
}
