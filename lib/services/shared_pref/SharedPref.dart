import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_mine.dart';
import '../data/get_user_datas.dart';
/*
class SharedPref {
  void saveConnectUserInfos() async {
    final data = await GetUserDatas().getConnectedUserInfos();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('user', jsonEncode(data.toMap()));
  }

  Future<UserMine> getUserInfos() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userPref = preferences.getString('user');
    return UserMine.fromJson(jsonDecode(userPref!) as Map<String, dynamic>);
  }

  void removeUserInfos() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('user');
  }
}*/
