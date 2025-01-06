import 'package:intl/intl.dart';

class FormatDate{
  String formatTaskDate(DateTime date) {

      return DateFormat("yMMMMEEEEd", 'fr_FR').format(date);

  }
}