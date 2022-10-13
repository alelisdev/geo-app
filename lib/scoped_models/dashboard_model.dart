import 'package:scoped_model/scoped_model.dart';
import 'package:geo_app_v2/api/api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

mixin DashboardModel on Model {

  Future<Map<String, dynamic>> getDashboardData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String url = "/dashboard";
    try {
      final http.Response response = await CallApi().getDataWithToken(
          url,
          token
      );
      final Map<String, dynamic> data = json.decode(response.body);
      return {"success": data["success"], "data": data["data"]};
    } catch (e) {
      return {"error": true, "msg": e.toString()};
    }
  }

}