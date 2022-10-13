// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:scoped_model/scoped_model.dart';
import 'package:geo_app_v2/api/api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

mixin LoginModel on Model {

  Future<Map<String, dynamic>> login(String? name, String? password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String url = '/login';
    final Map<String, dynamic> credentials = {"username": name, "password": password};
    try {
      final http.Response response = await CallApi().postData(url, credentials);
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['error'] != true) {
        prefs.setString('token', data['token']);
        prefs.setString('user', json.encode(data['user']));
      }
      return {"error": data['error'], "msg": data['message']};
    } catch(e) {
      return {"error": true, "msg": e.toString()};
    }
  }

  Future<Map<String, dynamic>> logout () async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> data = {"token": token};
    final http.Response response = await CallApi().postData(
        '/logout',
        data
    );
    if (response.statusCode == 500) {
      return {"error": true};
    }
    return {"error": false};
  }


  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> changePassword(String cPassword, String nPassword) async {
    final Map<String, dynamic> authData = {"cpassword": cPassword, "npassword": nPassword};
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await CallApi().postDataWithToken(
        '/changePassword',
        authData,
        prefs.getString('token')
    );
    final Map<String, dynamic> dataFound ;
    dataFound = json.decode(response.body);
    return {'success': dataFound['success'], 'data': dataFound['message']};
  }
}