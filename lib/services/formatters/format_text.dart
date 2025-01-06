class FormatText {
  String formatTitle(String text) {
    String title = "";
    List<String> list = text.split(" ");
    for (String value in list) {
      if (value.isEmpty) continue;

      if (value.length == 1) {
        title += " ${value.toUpperCase()}";
      } else {
        title += " ${value[0].toUpperCase()}${value.substring(1)}";
      }
    }

    return title/*.trim()*/; // Remove leading/trailing spaces
  }
  String formatDescription(String description){
    String format = description[0].toUpperCase() + description.substring(1);
    return format;
  }
}