// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:geo_app_v2/scoped_models/dashboard_model.dart';
import 'package:geo_app_v2/scoped_models/login_model.dart';
import 'package:geo_app_v2/scoped_models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AppModel extends Model with LoginModel, DashboardModel, UserModel {

  Future<Map<String, dynamic>> ifUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    if (token == "") {
      return {"success": false};
    } else {
      return {"success": true, "data": token};
    }
  }



  Future<Map<String, dynamic>> getLogedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user;
    if (prefs.getString('user') != '') {
      user = prefs.getString('user')!;
    } else {
      user = "";
    }
    return json.decode(user);
  }
}