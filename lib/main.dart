import 'package:flutter/material.dart';
import 'package:geo_app_v2/scoped_models/app_model.dart';
import 'package:geo_app_v2/ui/views/add_admin.dart';
import 'package:geo_app_v2/ui/views/add_cc.dart';
import 'package:geo_app_v2/ui/views/add_coord.dart';
import 'package:geo_app_v2/ui/views/add_fl.dart';
import 'package:geo_app_v2/ui/views/add_mr.dart';
import 'package:geo_app_v2/ui/views/add_sl.dart';
import 'package:geo_app_v2/ui/views/login_page.dart';
import 'package:geo_app_v2/ui/views/dashboard.dart';
import 'package:geo_app_v2/ui/views/my_profile.dart';
import 'package:geo_app_v2/ui/views/setting_page.dart';
import 'package:geo_app_v2/ui/views/users.dart';
import 'package:geo_app_v2/ui/views/view_profile.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  AppModel model = AppModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.green,
            colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.greenAccent)
        ),
        initialRoute: LoginPage.routeName,
        routes: {
          LoginPage.routeName: (context) {
            return const LoginPage();
          },
          Dashboard.routeName: (context) {
            return const Dashboard();
          },
          UsersPage.routeName: (context) {
            return const UsersPage();
          },
          AddAdmin.routeName : (context) {
            return const AddAdmin();
          },
          AddCoord.routeName : (context) {
            return const AddCoord();
          },
          AddSl.routeName : (context) {
            return const AddSl();
          },
          AddMr.routeName : (context) {
            return const AddMr();
          },
          AddFl.routeName : (context) {
            return const AddFl();
          },
          AddCc.routeName : (context) {
            return const AddCc();
          },
          SettingPage.routeName : (context) {
            return const SettingPage();
          },
          MyProfile.routeName: (context) {
            return const MyProfile();
          },
          ViewProfile.routeName : (context) {
            return const ViewProfile();
          },
        }
      ),
    );
  }
}
