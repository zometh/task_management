import 'package:cloud_firestore/cloud_firestore.dart';

class UserMine {
  final String id;
  final String prenom;
  final String nom;
  final String email;
  final Timestamp registerDate;
  final String imageUrl;
  const UserMine(
      {required this.id,
      required this.prenom,
      required this.nom,
      required this.email,
      required this.registerDate,
      required this.imageUrl});
  factory UserMine.fromJson(Map<String, dynamic> data) {
    return UserMine(
        imageUrl: data["imageUrl"],
        id: data["id"],
        prenom: data["prenom"],
        nom: data["nom"],
        email: data["email"],
        registerDate: data["registerDate"] ?? Timestamp.now());
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "prenom": prenom,
      "nom": nom,
      "email": email,
    };
  }
}
