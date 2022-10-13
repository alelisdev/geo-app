// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:scoped_model/scoped_model.dart';
import 'package:geo_app_v2/api/api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

mixin UserModel on Model {

  Future<Map<String, dynamic>> getUserData(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String url = "/get_user_data";
    try {
      final http.Response response = await CallApi().postDataWithToken(
          url,
          {"id" : id},
          token
      );
      final Map<String, dynamic> data = json.decode(response.body);
      return {"success": data["success"], "message": data['message'], "data": data["data"]};
    } catch (e) {
      return {"success": false, "msg": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getSelectedUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String selectedUser = "";
    selectedUser = prefs.getString('selectedUser')!;
    return json.decode(selectedUser);
  }


  Future<Map<String, dynamic>> getUsersMadeByUser(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String url = "/getUsersMadeByUser";
    try {
      final http.Response response = await CallApi().postDataWithToken(
        url,
        {"id": id},
        token
      );
      final Map<String, dynamic> data = json.decode(response.body);
      return {"success": true, "message": "success", "data": data['data'] };
    } catch (e) {
      return {"success": false, "message" : e.toString()};
    }
  }

  Future<Map<String, dynamic>> verifyUser( int? userId, String? state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = "/verifyUser";
    String? token = prefs.getString('token');
    try {
      final http.Response response = await CallApi().postDataWithToken(
        url,
        {'user_id' : userId, 'verificado' : state},
        token
      );
      final Map<String, dynamic> data = json.decode(response.body);
      return {"success": true, "message": data['message']};
    } catch (e) {
      return {"success": false, "message" : e.toString()};
    }
  }

  Future<Map<String, dynamic>> addAdminToDB(
      String? nombre,
      String? segundonombre,
      String? apellidopaterno,
      String? apellidomaterno,
      String? email,
      String? telefono,
      String? telefono2,
      String? username,
      String? password
      ) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String url = '/add_admin_db';
    final Map<String, dynamic> adminData = {
      "nombre" : nombre,
      "segundonombre" : segundonombre,
      "apellidopaterno" : apellidopaterno,
      "apellidomaterno" : apellidomaterno,
      "email" : email,
      "telefono" : telefono,
      "telefono2" : telefono2,
      "username" : username,
      "password" : password,
    };
    try {
      final http.Response response = await CallApi().postDataWithToken(url, adminData, token);
      final Map<String, dynamic> data = json.decode(response.body);
      if (response.statusCode == 200) {
        return {"success": data['success'], "msg": data['data']['message'], "id" : data['data']['id']};
      } else if (response.statusCode == 400) {
        String errorStr = "";
        Map<String, dynamic> errorData = json.decode(response.body);
        errorData['error'].forEach((key, value) {
          if (value.toString() != "") {
            errorStr += (value[0].toString() + '\n');
          }
        });
        return {"success" : false, "msg" : errorStr };
      }
      return {"success" : false, "msg": data['message']};
    } catch(e) {
      return {"success": false, "msg": e.toString()};
    }
  }

  Future<Map<String, dynamic>> addCoordToDB(
      String? nombre,
      String? segundonombre,
      String? apellidopaterno,
      String? apellidomaterno,
      String? email,
      String? telefono,
      String? telefono2,
      String? username,
      String? password
      ) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String url = '/add_coordinator_db';
    final Map<String, dynamic> coordData = {
      "nombre" : nombre,
      "segundonombre" : segundonombre,
      "apellidopaterno" : apellidopaterno,
      "apellidomaterno" : apellidomaterno,
      "email" : email,
      "telefono" : telefono,
      "telefono2" : telefono2,
      "username" : username,
      "password" : password,
    };
    try {
      final http.Response response = await CallApi().postDataWithToken(url, coordData, token);
      final Map<String, dynamic> data = json.decode(response.body);
      // if (response.statusCode == 200) {
      //   return {"success": data['success'], "data": data['data']};
      // }
      return {"success": data['success'], "msg": data['message']};
    } catch(e) {
      return {"success": false, "msg": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getUsers(String? id, String? hid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String url = "/getUsers";

    try {
      final http.Response response = await CallApi().postDataWithToken(
        url,
        {"id": id, "hid": hid},
        token
      );
      final Map<String, dynamic> data = json.decode(response.body);
      // if (data['error']) {
      //   return {"success": false, "data": data["message"]};
      // }
      return {"success": data["success"], "data": data["data"]};
    } catch (e) {
      return {"success": false, "data": null};
    }
  }

  Future<Map<String, dynamic>> getUsersCount(String? id, String? hid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String url = '/getUsersCount';

    try {
      final http.Response response = await CallApi().postDataWithToken(
        url,
        {"id": id, "hid": hid},
        token
      );
      final Map<String, dynamic> data = json.decode(response.body);
      return {"success": data['success'], "data": data['data']};
    } catch (e) {
      return {"success": false, "data": null};
    }
  }


}