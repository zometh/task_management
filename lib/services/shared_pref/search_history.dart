import 'package:shared_preferences/shared_preferences.dart';

class SearchHistory {
  saveSearch(String taskName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tasks = prefs.getStringList('search_history');
    if (tasks == null) {
      List<String> tasksHistory = [taskName];

      await prefs.setStringList('search_history', tasksHistory);
    } else {
      tasks.add(taskName);
      await prefs.setStringList('search_history', tasks);
    }
  }

  Future<List<String>> getSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tasks = prefs.getStringList('search_history');

    return (tasks == null) ? [] : tasks;
  }

  deleteSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
  }

  deleteOneSearchHistory(String taskName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tasks = prefs.getStringList('search_history');
    if (tasks != null) {
      tasks.remove(taskName);
      await prefs.setStringList('search_history', tasks);
    }
  }
}
