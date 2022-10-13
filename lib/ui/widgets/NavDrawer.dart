// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:geo_app_v2/config/appconfig.dart';
import 'package:geo_app_v2/custom/user_id.dart';
import 'package:geo_app_v2/scoped_models/app_model.dart';
import 'package:geo_app_v2/ui/views/dashboard.dart';
import 'package:geo_app_v2/ui/views/login_page.dart';
import 'package:geo_app_v2/ui/views/my_profile.dart';
import 'package:geo_app_v2/ui/views/setting_page.dart';
import 'package:geo_app_v2/ui/views/users.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NavDrawerState();
  }
}

class _NavDrawerState extends State<NavDrawer> {

  Map<String, dynamic>? _user;
  int _role = 1;

  @override
  void initState() {
    super.initState();
    ScopedModel.of<AppModel>(context).getLogedUser().then((user) {
      setState(() {
        _user = user;
        _role = int.parse(_user!['role']);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: _buildNavDrawerContent(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavDrawerContent() {
    return Column(
      children: <Widget>[
        AppBar(
          title: const Text(""),
          backgroundColor: AppConfig.APP_COLOR,
        ),
        ListTile(
          title: const Text("Dashboard"),
          leading: const Icon(Icons.home),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, Dashboard.routeName);
          },
        ),
        ListTile(
          title: const Text("Users"),
          leading: const Icon(Icons.people),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, UsersPage.routeName);
          },
        ),
        _buildExpansionLink(),
        ListTile(
          title: const Text("My Profile"),
          leading: const Icon(Icons.tv),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, MyProfile.routeName);
          },
        ),
        ListTile(
          title: const Text("Settings"),
          leading: const Icon(Icons.settings),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, SettingPage.routeName);
          },
        ),
        ListTile(
          title: const Text("Logout"),
          leading: const Icon(Icons.exit_to_app),
          onTap: () {
            ScopedModel.of<AppModel>(context).logout().then((res) async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            });
          },
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: const Align(
              alignment: FractionalOffset.bottomCenter,
              child: Text("Copyright© MRIC México 2022"),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpansionLink() {
      return ExpansionTile(
        leading: const Icon(Icons.person_add),
        title: const Text('Add User'),
        children: <Widget>[
          _buildAddAdminLink(),
          _buildAddCoordLink(),
          _buildAddSlLink(),
          _buildAddMrLink(),
          _buildAddFlLink(),
          _buildAddCcLink(),
        ],
      );
  }

  Widget _buildAddAdminLink() {
    return (_role < 2) ? Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ListTile(
        title: const Text("Agregar Administrador"),
        leading: const Icon(Icons.verified_user),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/add_admin');
        },
      ),
    ) : Container();
  }

  Widget _buildAddCoordLink() {
    return (_role < 3) ? Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ListTile(
        title: const Text("Agregar Coordinador"),
        leading: const Icon(Icons.admin_panel_settings),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/add_coord');
        },
      ),
    ) : Container();
  }

  Widget _buildAddSlLink() {
    return (_role < 4 ) ? Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ListTile(
        title: const Text("Agregar SL"),
        leading: const Icon(Icons.supervised_user_circle),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/add_sl');
        },
      ),
    ) : Container();
  }

  Widget _buildAddMrLink() {
    return (_role < 5) ? Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ListTile(
        title: const Text("Agregar MR"),
        leading: const Icon(Icons.person),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/add_mr');
        },
      ),
    ) :  Container();
  }

  Widget _buildAddFlLink() {
    return (_role < 6) ? Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ListTile(
        title: const Text("Agregar F"),
        leading: const Icon(Icons.family_restroom),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/add_fl');
        },
      ),
    ) : Container();
  }

  Widget _buildAddCcLink() {
    return (_role < 3) ? Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ListTile(
        title: const Text("Agregar Call Center"),
        leading: const Icon(Icons.local_library_rounded),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/add_cc');
        },
      ),
    ) : Container();
  }
}
