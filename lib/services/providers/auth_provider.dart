import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/services/data/get_user_datas.dart';

import '../../models/user_mine.dart';

class AuthProviderMine with ChangeNotifier {}
