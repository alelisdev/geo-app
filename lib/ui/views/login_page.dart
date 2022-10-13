// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:geo_app_v2/scoped_models/app_model.dart';
import 'package:geo_app_v2/ui/views/dashboard.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {

  static const String routeName = '/';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String? _username;
  String? _password;
  bool _isLoading = false;

  final GlobalKey<FormState> _formState = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _isLoading = false;

  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return Scaffold(
          // resizeToAvoidBottomInset: false,
          backgroundColor: Colors.greenAccent,
          body: ModalProgressHUD(
            inAsyncCall: _isLoading,
            child: _buildContent(),
          ),
        );
      },
    );
  }


  Widget _buildContent() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: Image.asset('assets/logo-full.png'),
                ),
                Card(
                  elevation: 4.0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: _buildForm(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formState,
      child: Padding(
        padding: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            top: 40.0,
            bottom: 40.0
        ),
        child: Column(
          children: <Widget>[
            _buildUsernameField(),
            const SizedBox(
              height: 10.0,
            ),
            _buildPasswordField(),
            const SizedBox(
              height: 20.0,
            ),
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      validator: (value) {
        if (value!.trim().isEmpty) {
          return 'Username is Required';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          _username = value!.trim();
        });
      },
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          icon: Icon(Icons.person),
          labelText: "Username",
          filled: true,
          fillColor: Colors.white
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Password is Required';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          _password = value;
        });
      },
      obscureText: true,
      decoration: const InputDecoration(
          icon: Icon(Icons.vpn_key),
          labelText: "Password",
          filled: true,
          fillColor: Colors.white
      ),
    );
  }

  Widget _buildLoginButton() {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return _loginButton(context, child, model);
      },
    );
  }

  Widget _loginButton(BuildContext context, Widget child, AppModel model) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: double.infinity,
        child: FlatButton(
          child: const Padding(
            padding: EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 10.0,
              right: 10.0,
            ),
            child: Text(
              'Login',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal
              ),
            ),
          ),
          color: Colors.green,
          disabledColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          onPressed: () {
            if (!_formState.currentState!.validate()) {
              return;
            }
            _formState.currentState!.save();
            setState(() {
              _isLoading = true;
            });
            model.login(_username, _password).then((res) {
              setState(() {
                _isLoading = false;
              });
              if (res['error'] != null) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(res['msg']),
                        actions: <Widget>[
                          FlatButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }
                );
              } else {
                Navigator.pushReplacementNamed(context, Dashboard.routeName);
              }
            });
          },
        ),
      ),
    );
  }



}



