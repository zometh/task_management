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
  String getMessageFromErrorCode(String errorCode) {
    switch (errorCode) {
      case "invalid-credential":
        return "Adresse email ou mot de passe incorrect";
      case "user-disabled":
        return "Votre compte est bloqué. Veuillez contacter l'administrateur";
      case "email-already-in-use":
        return "L'adresse email existe déja.";
      default:
        return "Connexion échouée. Veuillez réssayer plus tard";
    }
  }
}