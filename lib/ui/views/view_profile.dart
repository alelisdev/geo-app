// ignore_for_file: deprecated_member_use, import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:geo_app_v2/config/appconfig.dart';
import 'package:geo_app_v2/scoped_models/app_model.dart';
import 'package:geo_app_v2/ui/views/login_page.dart';
import 'package:geo_app_v2/ui/widgets/CustomBottomAppBar.dart';
import 'package:geo_app_v2/ui/widgets/NavDrawer.dart';
import 'package:geo_app_v2/ui/widgets/NotificationWidget.dart';
import 'package:scoped_model/scoped_model.dart';

class ViewProfile extends StatefulWidget {

  static const String routeName = '/profile';

  const ViewProfile({Key? key}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {

  bool _isLoading  = false;
  Map<String, dynamic>? _user;
  Map<String, dynamic>? _result;
  Map<String, dynamic>? _selectedUser;
  int _createdUsers = 0;
  int _role = 1;
  int _selectedUserRole = 1;
  String? _verifyStr;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
      _verifyStr = '';
    });

    ScopedModel.of<AppModel>(context).ifUserLoggedIn().then((result) {
      setState(() {
        _result = result;
      });
    });

    ScopedModel.of<AppModel>(context).getSelectedUser().then((res) {

      ScopedModel.of<AppModel>(context).getUsersMadeByUser(res['data']['id'].toString()).then((rlt) {

        ScopedModel.of<AppModel>(context).getLogedUser().then((user) {
          setState(() {
            _selectedUser = res['data'];
            _selectedUserRole = int.parse(_selectedUser!['role']);
            _createdUsers = rlt['data'] as int;
            _user = user;
            _role = int.parse(_user!['role']);
            _isLoading = false;
          });
        });
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

    // UserId? userid = ModalRoute.of(context)?.settings.arguments as UserId?;

    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
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
          // drawer: const NavDrawer(),
          bottomNavigationBar: CustomBottomAppBar(currentIndex: 3,),
        );
      },
    );
  }

  Widget _buildBody() {
    return   _isLoading ? _buildLoader() : _buildProfileContent();
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

  Widget _buildProfileContent() {
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
            _buildUserFullNameSection(),
            _buildActionBtnSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserFullNameSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "${_selectedUser!['nombre'] + ' ' + _selectedUser!['segundo_Nombre']}",
            style: const TextStyle(
                color: AppConfig.APP_COLOR,
                fontSize: 18,
                fontWeight: FontWeight.w500
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
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
            image: NetworkImage(AppConfig.WEB_BASE_URL + _selectedUser!['image'])
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
                  "@${_selectedUser!['username']}",
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  "${_selectedUser!['roleName']}",
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

  Widget _buildActionBtnSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildEditProfileBtn(),
          _buildGuardarBtn(),
          _buildEditPasswordBtn(),
          _buildDigitalIdBtn(),
          _buildDeleteUserBtn(),
        ],
      ),
    );
  }

  Widget _buildEditProfileBtn() {
    return (_role != 6 ) ? Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 1.0, top: 2.0),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          textColor: Colors.white,
          color: AppConfig.APP_COLOR,
          child: const Text("Editar Perfil"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          onPressed: () {

          },
        ),
      ),
    ) : Container();
  }

  Widget _buildGuardarBtn() {
    return (_role == 1 || _role == 2 || _role == 6 ) ? Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 1.0, top: 1.0),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          textColor: Colors.white,
          color: AppConfig.APP_PRIMARY_COLOR,
          child: const Text("Guardar"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          onPressed: () {

          },
        ),
      ),
    ) : Container();
  }

  Widget _buildEditPasswordBtn() {
    return (_role == 1 || _role == 2 ) ? Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 1.0, top: 1.0),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          textColor: Colors.white,
          color: AppConfig.APP_WARNING_COLOR,
          child: const Text("Edit Password"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          onPressed: () {

          },
        ),
      ),
    ) : Container();
  }

  Widget _buildDigitalIdBtn() {
    return  Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 1.0, top: 1.0),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          textColor: Colors.white,
          color: AppConfig.APP_SUCCESS_COLOR,
          child: const Text("Digital ID"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          onPressed: () {

          },
        ),
      ),
    );
  }

  Widget _buildDeleteUserBtn() {
    return (_role == 1 || _role == 2 ) ? Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 1.0),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          textColor: Colors.white,
          color: AppConfig.APP_DANGER_COLOR,
          child: const Text("Delete User"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          onPressed: () {

          },
        ),
      ),
    ) : Container();
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
        child: DefaultTabController(
          length: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const TabBar(tabs: [
                Tab(text: 'Sobre mi',),
                Tab(text: 'Verificación',),
              ],
                labelColor: Colors.black,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 1.5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 10.0, left: 30.0, right: 30.0),
                  child: TabBarView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Información Personal",
                              style: TextStyle(
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
                              _buildNameInfo(),
                              _buildSecondNameInfo(),
                              _buildAppelidaPathernoInfo(),
                              _buildAppelidaMathernoInfo(),

                              // conditional rendering due to user role
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Align(
                          alignment: Alignment.centerLeft,
                            child: Text(
                              "Verificado",
                              style: TextStyle(
                                  color: AppConfig.APP_COLOR,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Mensaje de llamada:\n“Hola,me llamo XXXXX, te hablo de la AC, para confirmar que te hayas afiliado a nuestra Red Verde voluntariamente, ¿es así?” "
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          _buildVerifyDropdown(),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ScopedModelDescendant<AppModel>(
                            builder: (BuildContext context, Widget child, AppModel model) {
                              return _buildVerifyBtn(context, child, model);
                            },
                          ),
                        ]
                      ),
                    ],
                  ),
                ),
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
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_selectedUser!['nombre']}"
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
                  "${_selectedUser!['segundo_Nombre']}"
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
                  "${_selectedUser!['apellido_Paterno']}"
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
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_selectedUser!['apellido_Materno']}"
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
                style:  TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${_selectedUser!['email']}"
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
                  "${_selectedUser!['telefono']}"
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
                  "${_selectedUser!['telefono2']}"
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
    return (_selectedUserRole == 3 || _selectedUserRole == 4 || _selectedUserRole == 5 || _selectedUserRole == 7 ) ? Column(
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
                  "${_selectedUser!['genero']}"
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

  Widget _buildEscolaridadInfo() {
    return (_selectedUserRole == 3 || _selectedUserRole == 4 || _selectedUserRole == 5 || _selectedUserRole == 7 ) ? Column(
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
                  "${_selectedUser!['escolaridad']}"
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

  Widget _buildClaveDeElectorInfo() {
    return (_selectedUserRole == 3 || _selectedUserRole == 4 || _selectedUserRole == 5 ) ? Column(
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
                  "${_selectedUser!['claveDeElector']}"
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

  Widget _buildEdadInfo() {
    return (_selectedUserRole == 7 ) ? Column(
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
                  "${_selectedUser!['edad']}"
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

  Widget _buildCURPClaveDeElectorInfo() {
    return (_selectedUserRole == 7 ) ? (
        (_selectedUser!['edad'] == "Mayor de edad") ? Column(
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
                      "${_selectedUser!['claveDeElector']}"
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
                      "${_selectedUser!['curp']}"
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
    return (_selectedUserRole == 3 || _selectedUserRole == 4 || _selectedUserRole == 5 || _selectedUserRole == 7 ) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
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
                  "${_selectedUser!['estado']}"
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

  Widget _buildSeccionInfo() {
    return (_selectedUserRole == 3 || _selectedUserRole == 4 || _selectedUserRole == 5 || _selectedUserRole == 7 ) ? Column(
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
                  "${_selectedUser!['seccion']}"
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

  Widget _buildCiudadInfo() {
    return (_selectedUserRole == 3 || _selectedUserRole == 4 || _selectedUserRole == 5 || _selectedUserRole == 7 ) ? Column(
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
                  "${_selectedUser!['ciudad']}"
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

  Widget _buildAlcaldiaoMunicipioInfo() {
    return (_selectedUserRole == 3 || _selectedUserRole == 4 || _selectedUserRole == 5 || _selectedUserRole == 7 ) ? Column(
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
                  "${_selectedUser!['alcaldiaoMunicipio']}"
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
    return (_selectedUserRole == 3 || _selectedUserRole == 4 || _selectedUserRole == 5 || _selectedUserRole == 7 ) ? Column(
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
                  "${_selectedUser!['colonia']}"
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
    return (_selectedUserRole == 3 || _selectedUserRole == 4 || _selectedUserRole == 5 || _selectedUserRole == 7 ) ? Column(
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
                  "${_selectedUser!['calle']}"
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
    return (_selectedUserRole == 3 || _selectedUserRole == 4 || _selectedUserRole == 5 || _selectedUserRole == 7 ) ? Column(
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
                  "${_selectedUser!['exterior']}"
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
    return (_selectedUserRole == 3 || _selectedUserRole == 4 || _selectedUserRole == 5 || _selectedUserRole == 7 ) ? Column(
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
                  "${_selectedUser!['interior']}"
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
    return (_selectedUserRole == 3 || _selectedUserRole == 4 || _selectedUserRole == 5 || _selectedUserRole == 7 ) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
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
                  "${_selectedUser!['codigopostal']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ]
    ): Container();
  }

  Widget _buildFacebookInfo() {
    return (_selectedUserRole == 3 || _selectedUserRole == 4 || _selectedUserRole == 5 || _selectedUserRole == 7 ) ? Column(
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
                  "${_selectedUser!['facebook']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        )
      ]
    ): Container();
  }

  Widget _buildTwitterInfo() {
    return (_selectedUserRole == 3 || _selectedUserRole == 4 || _selectedUserRole == 5 || _selectedUserRole == 7 ) ? Column(
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
                  "${_selectedUser!['twitter']}"
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0
        )
      ]
    ): Container();
  }

  Widget _buildInstagramInfo() {
    return (_selectedUserRole == 3 || _selectedUserRole == 4 || _selectedUserRole == 5 || _selectedUserRole == 7 ) ? Column(
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
                  "${_selectedUser!['instagram']}"
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

  Widget _buildVerifyDropdown() {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              DropDownFormField(
                titleText: 'Right ?',
                hintText: 'Please choose one',
                value: _verifyStr,
                validator: (value) {
                  if (value == "" || value == null) return "Filed is required!";
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _verifyStr = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    _verifyStr = value;
                  });
                },
                dataSource: const [
                  {
                    "display" : "Selecciona",
                    "value" : ""
                  },
                  {
                    "display" : "SI",
                    "value" : "SI"
                  },
                  {
                    "display" : "NO",
                    "value" : "NO"
                  },
                ],
                textField: "display",
                valueField: "value",
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildVerifyBtn(BuildContext context, Widget child, AppModel model) {
    return  (_role == 1 || _role == 2 || _role == 6 ) ? Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 1.0),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          textColor: Colors.white,
          color: AppConfig.APP_SUCCESS_COLOR,
          child: const Text("Enviar"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          onPressed: () {
            var _form = formKey.currentState;
            if ( !_form!.validate() ) {
              return ;
            }
            // setState(() {
            //   _isLoading = true;
            // });
            _form.save();
            model.verifyUser(_selectedUser!['id'], _verifyStr).then((res) {
              setState(() {
                _isLoading = false;
              });
              if (res['success'] == true) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(res['message']),
                        actions: <Widget>[
                          FlatButton(
                            color: AppConfig.APP_SUCCESS_COLOR,
                            child: const Text('Ok'),
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }
                );
              } else {
                // print("failed: ${res['message']}");
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(res['message']),
                        actions: <Widget>[
                          FlatButton(
                            color: AppConfig.APP_WARNING_COLOR,
                            child: const Text('Got it'),
                            onPressed: () async {
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
    ) : Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 1.0),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          disabledColor: Colors.black12,
          disabledElevation: 1,
          disabledTextColor: Colors.blueGrey,
          child: const Text("Enviar"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          onPressed: () {

          },
        ),
      ),
    );
  }

}

