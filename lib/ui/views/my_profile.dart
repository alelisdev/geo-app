// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geo_app_v2/config/appconfig.dart';
import 'package:geo_app_v2/scoped_models/app_model.dart';
import 'package:geo_app_v2/ui/views/login_page.dart';
import 'package:geo_app_v2/ui/widgets/CustomBottomAppBar.dart';
import 'package:geo_app_v2/ui/widgets/NavDrawer.dart';
import 'package:geo_app_v2/ui/widgets/NotificationWidget.dart';
import 'package:scoped_model/scoped_model.dart';

class MyProfile extends StatefulWidget {

  static const String routeName = '/myProfile';

  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  bool _isLoading  = false;
  Map<String, dynamic>? _user;
  Map<String, dynamic>? _result;
  int _createdUsers = 0;
  int _role = 1;
  String? _verifyStr;

  Map<String, String> roles = {
    "1": "Super Admin",
    "2": "Administrator",
    "3": "Coordinador",
    "4": "Seccional",
    "5": "Movilizador",
    "6": "Call Center",
    "7": "Familiar"
  };

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _verifyStr = '';
    _getUtils();
  }

  Future<void> _getUtils() async {
    ScopedModel.of<AppModel>(context).ifUserLoggedIn().then((result) {
      setState(() {
        _result = result;
      });
    });

    ScopedModel.of<AppModel>(context).getLogedUser().then((user) {
      ScopedModel.of<AppModel>(context).getUsersMadeByUser(user['id'].toString()).then((rlt) {
        setState(() {
          _createdUsers = rlt['data'] as int;
        });
      });
      setState(() {
        _user = user;
        _role = int.parse(_user!['role']);
        _isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
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
              "Profil",
              textAlign: TextAlign.center,
            ),
            actions: const <Widget>[
              NotificationWidget(),
            ],
          ),
          body: _buildBody(),
          drawer: const NavDrawer(),
          bottomNavigationBar: CustomBottomAppBar(currentIndex: 3,),
        );
      },
    );
  }

  Widget _buildBody() {
    return  _isLoading ? _buildLoader() : _buildDashboard();
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

  Widget _buildDashboard() {
    if (_result!["success"] == false) {
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    }
    return CupertinoScrollbar(
      thickness: 5,
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHeaderSection(),
                _buildBodySection(),
              ],
            ),
          ),
        ),
      ),
      isAlwaysShown: false,
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        color: Colors.white,
        elevation: 4.0,
        borderRadius: const BorderRadius.all(
          Radius.circular(20.0),
        ),
        shadowColor: Colors.black87,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildAvatarSection(),
            Text(
              "${_user!['nombre'] + ' ' + _user!['segundo_Nombre']}",
              style: const TextStyle(
                  color: AppConfig.APP_COLOR,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildAvatarImage(),
        _buildAvatarInfo(),
      ],
    );
  }

  Widget _buildAvatarImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(AppConfig.WEB_BASE_URL + _user!['image'])
            )
        ),
      ),
    );
  }

  Widget _buildAvatarInfo() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "@${_user!['username']}",
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  "${roles[_user!['role'].toString()]}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal
                  ),
                )
              ],
            ),
          ),
          _buildUserCntSection(),
        ],
      ),
    );
  }

  Widget _buildUserCntSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            _createdUsers.toString(),
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
          const Text(
            "Usuarios Creados",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodySection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        color: Colors.white,
        elevation: 4.0,
        borderRadius: const BorderRadius.all(
          Radius.circular(20.0),
        ),
        shadowColor: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 10.0, left: 30.0, right: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Align(
                alignment: Alignment.centerLeft,
                child:  Text(
                  "Información Personal",
                  style:  TextStyle(
                      color: AppConfig.APP_COLOR,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              const Divider(
                height: 1.0,
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _buildNameInfo(),
                  _buildSecondNameInfo(),
                  _buildAppelidaPathernoInfo(),
                  _buildAppelidaMathernoInfo(),

                  // conditional rendering due to user role
                  const SizedBox(
                    height: 10.0,
                  ),
                  _buildGenderInfo(),
                  _buildEscolaridadInfo(),
                  _buildClaveDeElectorInfo(),
                  _buildEdadInfo(),
                  _buildCURPClaveDeElectorInfo(),
                  _buildEstadoInfo(),
                  _buildSeccionInfo(),
                  _buildCiudadInfo(),
                  _buildAlcaldiaoMunicipioInfo(),
                  _buildColoniaInfo(),
                  _buildCalleInfo(),
                  _buildExteriorInfo(),
                  _buildInteriorInfo(),
                  _buildCodigopostalInfo(),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Contacto",
                  style:  TextStyle(
                      color: AppConfig.APP_COLOR,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _buildEmailInfo(),
                  _buildPhoneInfo(),
                  _buildPhone2Info(),

                  // conditional rendering due to user role
                  _buildFacebookInfo(),
                  _buildTwitterInfo(),
                  _buildInstagramInfo(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Nombre : ",
                style:  TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['nombre']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget _buildSecondNameInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Segundo Nombre : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['segundo_Nombre']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget _buildAppelidaPathernoInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Apellido Paterno : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['apellido_Paterno']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget _buildAppelidaMathernoInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Apellido Materno : ",
                style:  TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['apellido_Materno']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget _buildEmailInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Email : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['email']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget _buildPhoneInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Celular : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['telefono']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget _buildPhone2Info() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Teléfono 2 : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['telefono2']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget _buildGenderInfo() {
    return (_role == 3 || _role == 4 || _role == 5 || _role == 7 ) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Género : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['genero']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    ) : Container();
  }

  Widget _buildEscolaridadInfo() {
    return (_role == 3 || _role == 4 || _role == 5 || _role == 7 ) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Escolaridad : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['escolaridad']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    ) : Container();
  }

  Widget _buildClaveDeElectorInfo() {
    return (_role == 3 || _role == 4 || _role == 5 ) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Clave de Elector : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['claveDeElector']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    ) : Container();
  }

  Widget _buildEdadInfo() {
    return (_role == 7 ) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Edad : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['edad']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    ) : Container();
  }

  Widget _buildCURPClaveDeElectorInfo() {
    return (_role == 7 ) ? (
        (_user!['edad'] == "Mayor de edad") ? Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Clave de Elector : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                      "${_user!['claveDeElector']}"
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            )
          ],
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "CURP : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                      "${_user!['curp']}"
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            )
          ],
        )
    ): Container();
  }

  Widget _buildEstadoInfo() {
    return (_role == 3 || _role == 4 || _role == 5 || _role == 7 ) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Contacto",
            style: TextStyle(
                color: AppConfig.APP_COLOR,
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Estado : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['estado']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    ) : Container();
  }

  Widget _buildSeccionInfo() {
    return (_role == 3 || _role == 4 || _role == 5 || _role == 7 ) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Sección : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['seccion']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    ) : Container();
  }

  Widget _buildCiudadInfo() {
    return (_role == 3 || _role == 4 || _role == 5 || _role == 7 ) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Ciudad : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['ciudad']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    ) : Container();
  }

  Widget _buildAlcaldiaoMunicipioInfo() {
    return (_role == 3 || _role == 4 || _role == 5 || _role == 7 ) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Alcaldía o Municipio : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['alcaldiaoMunicipio']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    ): Container();
  }

  Widget _buildColoniaInfo() {
    return (_role == 3 || _role == 4 || _role == 5 || _role == 7 ) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Colonia : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['colonia']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    ): Container();
  }

  Widget _buildCalleInfo() {
    return (_role == 3 || _role == 4 || _role == 5 || _role == 7 ) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Calle : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['calle']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    ): Container();
  }

  Widget _buildExteriorInfo() {
    return (_role == 3 || _role == 4 || _role == 5 || _role == 7 ) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "No. Exterior : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['exterior']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    ): Container();
  }

  Widget _buildInteriorInfo() {
    return (_role == 3 || _role == 4 || _role == 5 || _role == 7 ) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "No. Interior : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['interior']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    ): Container();
  }

  Widget _buildCodigopostalInfo() {
    return (_role == 3 || _role == 4 || _role == 5 || _role == 7 ) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Código Postal : ",
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
              "${_user!['codigopostal']}"
          ),
        ),
      ],
    ): Container();
  }

  Widget _buildFacebookInfo() {
    return (_role == 3 || _role == 4 || _role == 5 || _role == 7 ) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Usuario de Facebook : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['facebook']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    ): Container();
  }

  Widget _buildTwitterInfo() {
    return (_role == 3 || _role == 4 || _role == 5 || _role == 7 ) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Usuario de Twitter : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['twitter']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    ): Container();
  }

  Widget _buildInstagramInfo() {
    return (_role == 3 || _role == 4 || _role == 5 || _role == 7 ) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Usuario de Instagram : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_user!['instagram']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    ): Container();
  }

}

