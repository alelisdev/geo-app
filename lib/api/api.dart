import 'package:http/http.dart' as http;
import 'package:geo_app_v2/config/appconfig.dart';
import 'dart:convert';

class CallApi {
  final String apiUrl = AppConfig.BASE_URL;

  postData(url, data) async {
    String fullUrl = apiUrl + url;
    return await http.post(
        Uri.parse(fullUrl),
        body: json.encode(data),
        headers: _setHeaders()
    );
  }

  postDataWithToken(url, data, token) async {
    String fullUrl = apiUrl + url;
    return await http.post(
        Uri.parse(fullUrl),
        body: json.encode(data),
        headers: _setHeadersWithToken(token)
    );
  }

  getData(url) async {
    String fullUrl = apiUrl + url;
    return await http.get(
        Uri.parse(fullUrl),
        headers: _setHeaders()
    );
  }

  getDataWithToken(url, token) async {
    String fullUrl = apiUrl + url;
    return await http.get(
        Uri.parse(fullUrl),
        headers: _setHeadersWithToken(token)
    );
  }

  _setHeaders() => {
    "Content-Type" : "application/json",
    "Accept" : "application/json"
  };

  _setHeadersWithToken(token) => {
    "Content-Type" : "application/json",
    "Accept" : "application/json",
    "Authorization" : "Bearer $token"
  };
}