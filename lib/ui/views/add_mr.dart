import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geo_app_v2/config/appconfig.dart';
import 'package:geo_app_v2/scoped_models/app_model.dart';
import 'package:geo_app_v2/ui/widgets/CustomBottomAppBar.dart';
import 'package:geo_app_v2/ui/widgets/NavDrawer.dart';
import 'package:geo_app_v2/ui/widgets/NotificationWidget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';


class AddMr extends StatefulWidget {

  static const String routeName = '/add_mr';

  const AddMr({Key? key}) : super(key: key);

  @override
  State<AddMr> createState() => _AddMrState();
}

class _AddMrState extends State<AddMr> {

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

  final GlobalKey<FormState> _formKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConfig.APP_COLOR,
        title: Text(
          "Agregar Movilizador",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          NotificationWidget(),
        ],
      ),
      body: _buildBody(),
      drawer: NavDrawer(),
      bottomNavigationBar: CustomBottomAppBar(currentIndex: 2,),
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
          children: <Widget>[
            const Text("Loading data..."),
            CircularProgressIndicator(),
          ],
        )
    );
  }

  Widget _buildContent() {
    if (_result!["success"] == false) {
      Navigator.pushReplacementNamed(context, "/");
    }
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Material(
                  color: Colors.white,
                  elevation: 10.0,
                  borderRadius: BorderRadius.all(
                    Radius.circular(40.0),
                  ),
                  shadowColor: Colors.black87,
                  child: Container(
                    padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          _buildTitle(),
                          Padding(
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
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        'Datos De Movilizador User',
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
            SizedBox(
              height: 10.0,
            ),
            _buildSegundoNombreField(),
            SizedBox(
              height: 10.0,
            ),
            _buildApellidoPaternoField(),
            SizedBox(
              height: 10.0,
            ),
            _buildApellidoMaternoField(),
            SizedBox(
              height: 10.0,
            ),
            _buildEmailField(),
            SizedBox(
              height: 10.0,
            ),
            _buildTelefonoField(),
            SizedBox(
              height: 10.0,
            ),
            _buildTelefono2Field(),
            SizedBox(
              height: 10.0,
            ),
            _buildUsernameField(),
            SizedBox(
              height: 10.0,
            ),
            _buildPasswordField(),
            SizedBox(
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
      },
      onSaved: (value) {
        setState(() {
          _nombre = value!.trim();
        });
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
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
      decoration: InputDecoration(
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
      },
      onSaved: (value) {
        setState(() {
          _apellidopaterno = value!.trim();
        });
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
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
      },
      onSaved: (value) {
        setState(() {
          _apellidomaterno = value!.trim();
        });
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
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
      },
      onSaved: (value) {
        setState(() {
          _email = value!.trim();
        });
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
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
      },
      onSaved: (value) {
        setState(() {
          _telefono = value!.trim();
        });
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
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
      decoration: InputDecoration(
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
      },
      onSaved: (value) {
        setState(() {
          _username = value!.trim();
        });
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
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
      },
      onSaved: (value) {
        setState(() {
          _password = value;
        });
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
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
          child: Padding(
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
                print("success");
                // showDialog(
                //     context: context,
                //     builder: (BuildContext context) {
                //       return AlertDialog(
                //         content: Text(res['msg']),
                //         actions: <Widget>[
                //           FlatButton(
                //             child: const Text('OK'),
                //             onPressed: () {
                //               Navigator.of(context).pop();
                //             },
                //           ),
                //         ],
                //       );
                //     }
                // );
              } else {
                print("failed");
                // showDialog<void>(
                //     context: context,
                //     barrierDismissible: false,
                //     builder: (BuildContext context) {
                //       return AlertDialog(
                //         content: Text(res['msg']),
                //         actions: <Widget>[
                //           FlatButton(
                //             child: const Text('Got it'),
                //             onPressed: () {
                //               Navigator.of(context).pop();
                //             },
                //           ),
                //         ],
                //       );
                //     }
                // );
              }
            });
          },
        ),
      ),
    );
  }


}
