// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_mine.dart';

class GetUserDatas {
  Stream<DocumentSnapshot<Map<String, dynamic>>> getConnectedUserInfos() {
    final uid = FirebaseAuth.instance.currentUser!.uid;


    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllTasks(){
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('tasks').where('idUser', isEqualTo: uid).snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getDoneTasks(){
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('tasks').where('idUser', isEqualTo: uid).where('state', isEqualTo: 1).snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getTodoTasks(){
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('tasks').where('idUser', isEqualTo: uid).where('state', isEqualTo: 3).snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getOnprogressTasks(){
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('tasks').where('idUser', isEqualTo: uid).where('state', isEqualTo: 2).snapshots();
  }

}
