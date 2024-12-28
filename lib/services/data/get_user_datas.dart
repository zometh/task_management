import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_mine.dart';

class GetUserDatas {
  Stream<DocumentSnapshot<Map<String, dynamic>>> getConnectedUserInfos() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final stream =
        FirebaseFirestore.instance.collection('users').doc(uid).get();

    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }
}
