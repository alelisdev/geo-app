// ignore_for_file: deprecated_member_use, import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geo_app_v2/config/appconfig.dart';
import 'package:geo_app_v2/scoped_models/app_model.dart';
import 'package:geo_app_v2/ui/views/login_page.dart';
import 'package:geo_app_v2/ui/widgets/CustomBottomAppBar.dart';
import 'package:geo_app_v2/ui/widgets/NavDrawer.dart';
import 'package:geo_app_v2/ui/widgets/NotificationWidget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddAdmin extends StatefulWidget {
  static const String routeName = '/add_admin';
  const AddAdmin({Key? key}) : super(key: key);

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {

  bool _isLoading = false;
  Map<String, dynamic>? _result;
  Map<String, dynamic>? _user;

  String? _nombre;
  String? _segundonombre;
  String? _apellidopaterno;
  String? _apellidomaterno;
  String? _email;
  String? _telefono;
  String? _telefono2;
  String? _username;
  String? _password;

  final _nombreController = TextEditingController();
  final _segundonombreController = TextEditingController();
  final _apellidopaternoController = TextEditingController();
  final _apellidomaternoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _telefono2Controller = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  NavigatorState? _navigator;


  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _navigator = Navigator.of(context);
    _getUtils();
  }

  Future<void> _getUtils() async {
    ScopedModel.of<AppModel>(context).ifUserLoggedIn().then((result) {
      setState(() {
        _result = result;
      });
    });

    ScopedModel.of<AppModel>(context).getLogedUser().then((user) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConfig.APP_COLOR,
            title: const Text(
              "Agregar Administrador",
              textAlign: TextAlign.center,
            ),
            actions: const <Widget>[
              NotificationWidget(),
            ],
          ),
          body: _buildBody(),
          drawer: const NavDrawer(),
          bottomNavigationBar: CustomBottomAppBar(currentIndex: 2,),
        );
      },
    );
  }

  Widget _buildBody() {
    return _isLoading ? _buildLoader() : _buildContent();
  }

  Widget _buildLoader() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const<Widget>[
            Text(
              "Loading data...",
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

  Widget _buildContent() {
    if (_result!["success"] == false) {
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    }
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Material(
                color: Colors.white,
                elevation: 10.0,
                borderRadius: const BorderRadius.all(
                  Radius.circular(40.0),
                ),
                shadowColor: Colors.black87,
                child: Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        _buildTitle(),
                        const Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Divider(
                              color: Colors.black
                          ),
                        ),
                        _buildAddAdminForm(context, child, model),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return const Align(
      alignment: Alignment.center,
      child: Text(
        'Datos De Administrator',
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal
        ),
      ),
    );
  }

  Widget _buildAddAdminForm(BuildContext context, Widget child, AppModel model) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 10.0,
            bottom: 10.0
        ),
        child: Column(
          children: <Widget>[
            _buildNombreField(),
            const SizedBox(
              height: 10.0,
            ),
            _buildSegundoNombreField(),
            const SizedBox(
              height: 10.0,
            ),
            _buildApellidoPaternoField(),
            const SizedBox(
              height: 10.0,
            ),
            _buildApellidoMaternoField(),
            const SizedBox(
              height: 10.0,
            ),
            _buildEmailField(),
            const SizedBox(
              height: 10.0,
            ),
            _buildTelefonoField(),
            const SizedBox(
              height: 10.0,
            ),
            _buildTelefono2Field(),
            const SizedBox(
              height: 10.0,
            ),
            _buildUsernameField(),
            const SizedBox(
              height: 10.0,
            ),
            _buildPasswordField(),
            const SizedBox(
              height: 20.0,
            ),
            _buildSaveButton(context, child, model),
          ],
        ),
      ),
    );
  }

  Widget _buildNombreField() {
    return TextFormField(
      controller: _nombreController,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return 'Nombre is Required';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          _nombre = value!.trim();
        });
      },
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "Nombre",
          filled: true,
          fillColor: Colors.white
      ),
    );
  }

  Widget _buildSegundoNombreField() {
    return TextFormField(
      controller: _segundonombreController,
      onSaved: (value) {
        setState(() {
          _segundonombre = value!.trim();
        });
      },
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "Segundo Nombre",
          filled: true,
          fillColor: Colors.white
      ),
    );
  }

  Widget _buildApellidoPaternoField() {
    return TextFormField(
      controller: _apellidopaternoController,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return 'Apellido Paterno is Required';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          _apellidopaterno = value!.trim();
        });
      },
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "Apellido Paterno",
          filled: true,
          fillColor: Colors.white
      ),
    );
  }

  Widget _buildApellidoMaternoField() {
    return TextFormField(
      controller: _apellidomaternoController,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return 'Apellido Materno  is Required';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          _apellidomaterno = value!.trim();
        });
      },
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "Apellido Materno",
          filled: true,
          fillColor: Colors.white
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return 'Email is Required';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          _email = value!.trim();
        });
      },
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "Email",
          filled: true,
          fillColor: Colors.white
      ),
    );
  }

  Widget _buildTelefonoField() {
    return TextFormField(
      controller: _telefonoController,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return 'Teléfono is Required';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          _telefono = value!.trim();
        });
      },
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "Teléfono",
          filled: true,
          fillColor: Colors.white
      ),
    );
  }

  Widget _buildTelefono2Field() {
    return TextFormField(
      controller: _telefono2Controller,
      onSaved: (value) {
        setState(() {
          _telefono2 = value!.trim();
        });
      },
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "Teléfono 2",
          filled: true,
          fillColor: Colors.white
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return 'Nombre de Usuario is Required';
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
          labelText: "Nombre de Usuario",
          filled: true,
          fillColor: Colors.white
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return 'Contraseña is Required';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          _password = value;
        });
      },
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "Contraseña",
          filled: true,
          fillColor: Colors.white
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, Widget child, AppModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
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
              'Enviar',
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
            if (!_formKey.currentState!.validate()) {
              return;
            }
            _formKey.currentState!.save();
            setState(() {
              _isLoading = true;
            });
            model.addAdminToDB(
              _nombre,
              _segundonombre,
              _apellidopaterno,
              _apellidomaterno,
              _email,
              _telefono,
              _telefono2,
              _username,
              _password
            ).then((res) {
              setState(() {
                _isLoading = false;
              });
              if (res['success'] == true) {
                showDialog(
                    context: _navigator!.context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(res['msg']),
                        actions: <Widget>[
                          FlatButton(
                            color: AppConfig.APP_SUCCESS_COLOR,
                            child: const Text('Verify User'),
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              ScopedModel.of<AppModel>(context).getUserData(res['id'].toString())
                                  .then((selectedUser) {
                                prefs.setString('selectedUser', json.encode(selectedUser));
                                _navigator?.pop();
                                _navigator?.pushNamed('/profile');
                              });
                            },
                          ),
                          FlatButton(
                            color: AppConfig.APP_PRIMARY_COLOR,
                            child: const Text('Ok'),
                            onPressed: () {
                              _navigator?.pop();
                            },
                          ),
                        ],
                      );
                    }
                );
              } else {
                showDialog(
                    context: _navigator!.context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(res['msg']),
                        actions: <Widget>[
                          FlatButton(
                            color: AppConfig.APP_WARNING_COLOR,
                            child: const Text('Got it'),
                            onPressed: () {
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
    );
  }




}
