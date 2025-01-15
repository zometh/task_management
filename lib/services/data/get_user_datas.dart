// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_mine.dart';

class GetUserDatas {
  Stream<DocumentSnapshot<Map<String, dynamic>>> getConnectedUserInfos() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllTasks() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('idUser', isEqualTo: uid)
        .orderBy('priority')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDoneTasks() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('idUser', isEqualTo: uid)
        .where('state', isEqualTo: 1)
        .orderBy('priority')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTodoTasks() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('idUser', isEqualTo: uid)
        .where('state', isEqualTo: 3)
        .orderBy('priority')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOnprogressTasks() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('idUser', isEqualTo: uid)
        .where('state', isEqualTo: 2)
        .orderBy('priority')
        .snapshots();
  }

  Future<bool> isExistMail(String mail) async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: mail)
        .get();

    return (data.docs.isNotEmpty) ? true : false;
  }
}
