

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
