// ignore_for_file: import_of_legacy_library_into_null_safe, must_be_immutable

import 'package:flutter/material.dart';
import 'package:geo_app_v2/scoped_models/app_model.dart';
import 'package:geo_app_v2/ui/views/dashboard.dart';
import 'package:geo_app_v2/ui/views/my_profile.dart';
import 'package:geo_app_v2/ui/views/setting_page.dart';
import 'package:geo_app_v2/ui/views/users.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomBottomAppBar extends StatefulWidget {

  int currentIndex;

  CustomBottomAppBar({
    Key? key,
    required this.currentIndex
  }) : super(key: key);

  @override
  State<CustomBottomAppBar> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {

  int _currentIndex = 0;

  @override
  void initState() {
    _currentIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (BuildContext context, Widget child, AppModel model) {
          return BottomAppBar(
            child: Container(
              margin: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10,),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                        Navigator.pushReplacementNamed(context, Dashboard.routeName);
                      },
                      iconSize: 22,
                      icon: Icon(
                        Icons.home,
                        color: (_currentIndex == 0) ? Colors.green : Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex = 1;
                        });
                        Navigator.pushReplacementNamed(context, UsersPage.routeName);
                      },
                      iconSize: 22,
                      icon: Icon(
                        Icons.people,
                        color: (_currentIndex == 1) ? Colors.green : Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex = 2;
                        });
                        // Navigator.pushReplacementNamed(context, '/dashboard');
                      },
                      iconSize: 22,
                      icon: Icon(
                        Icons.person_add,
                        color: (_currentIndex == 2) ? Colors.green : Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex = 3;
                        });
                        Navigator.pushReplacementNamed(context, MyProfile.routeName);
                      },
                      iconSize: 22,
                      icon: Icon(
                        Icons.tv,
                        color: (_currentIndex == 3) ? Colors.green : Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex = 4;
                        });
                        Navigator.pushReplacementNamed(context, SettingPage.routeName);
                      },
                      iconSize: 22,
                      icon: Icon(
                        Icons.settings,
                        color: (_currentIndex == 4) ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}
