// ignore_for_file: import_of_legacy_library_into_null_safe, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_app_v2/config/appconfig.dart';
import 'package:geo_app_v2/scoped_models/app_model.dart';
import 'package:geo_app_v2/ui/views/login_page.dart';
import 'package:geo_app_v2/ui/widgets/CustomBottomAppBar.dart';
import 'package:geo_app_v2/ui/widgets/NavDrawer.dart';
import 'package:geo_app_v2/ui/widgets/NotificationWidget.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingPage extends StatefulWidget {

  static const String routeName = '/setting';

  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  bool _isLoading  = false;
  Map<String, dynamic>? _result;

  String? _npassword;
  String? _cpassword;
  String? _vpassword;

  final _myControllerCpassword = TextEditingController();
  final _myControllerNpassword = TextEditingController();
  final _myControllerVpassword = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _isLoading = true;

    _getUtils();
  }

  Future<void> _getUtils() async {
    ScopedModel.of<AppModel>(context).ifUserLoggedIn().then((result) {
      setState(() {
        _result = result;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConfig.APP_COLOR,
            title: const Text("Change Password"),
            actions: const <Widget>[
              NotificationWidget(),
            ],
          ),
          body: _buildBody(context, child, model),
          drawer: const NavDrawer(),
          bottomNavigationBar: CustomBottomAppBar(currentIndex: 4,),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, Widget child, AppModel model) {
    return _isLoading ? _buildLoader() : _buildSettingBody(context, child, model);
  }

  Widget _buildLoader() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const<Widget>[
            Text(
              "Please wait...",
              style: TextStyle(
                  fontSize: 16,
                  color: AppConfig.APP_COLOR
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            CircularProgressIndicator(),
          ],
        )
    );
  }

  Widget _buildSettingBody(BuildContext context, Widget child, AppModel model) {
    if (_result!["success"] == false) {
      Navigator.of(context).pushReplacementNamed( LoginPage.routeName);
    }
    return CupertinoScrollbar(
      thickness: 5,
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0,
                        bottom: 30.0,
                        left: 15.0,
                        right: 15.0
                    ),
                    child: Material(
                      color: Colors.white,
                      elevation: 5.0,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      shadowColor: Colors.purple,
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 15.0,
                                ),
                                TextFormField(
                                  controller: _myControllerCpassword,
                                  validator: (value) {
                                    if(value!.isEmpty) {
                                      return "Password is required!";
                                    }
                                    return null;
                                  },
                                  onSaved: (String? value) {
                                    setState(() {
                                      _cpassword = value;
                                    });
                                  },
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      labelText: "Current Password",
                                      filled: true,
                                      fillColor: Colors.white
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  controller: _myControllerNpassword,
                                  validator: (value) {
                                    if(value!.isEmpty) {
                                      return "New Password is required!";
                                    }
                                    return null;
                                  },
                                  onSaved: (String? value) {
                                    setState(() {
                                      _npassword = value;
                                    });
                                  },
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      labelText: "New Password",
                                      filled: true,
                                      fillColor: Colors.white
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  controller: _myControllerVpassword,
                                  validator: (value) {
                                    if(value!.isEmpty) {
                                      return "Confirm Password is required!";
                                    }
                                    if(value != _myControllerNpassword.text) {
                                      return "Confirm Password doesn't match!";
                                    }
                                    return null;
                                  },
                                  onSaved: (String? value) {
                                    setState(() {
                                      _vpassword = value;
                                    });
                                  },
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      labelText: "Confirm Password",
                                      filled: true,
                                      fillColor: Colors.white
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: RaisedButton(
                                    textColor: Colors.white,
                                    color: Colors.green,
                                    child: const Text("Change Password"),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    onPressed: () {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }
                                      _formKey.currentState?.save();
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      model.changePassword(_cpassword!, _npassword!).then((value) {
                                        if (value['success'] == true) {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text(value['data']),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child:  const Text("Ok"),
                                                      onPressed: () {
                                                        _formKey.currentState?.reset();
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              }
                                          );
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text(value['data']),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: const Text("OK"),
                                                      onPressed: () {
                                                        _formKey.currentState?.reset();
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              }
                                          );
                                        }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      isAlwaysShown: false,
    );

  }

}

