// ignore_for_file: import_of_legacy_library_into_null_safe, deprecated_member_use, unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_app_v2/scoped_models/app_model.dart';
import 'package:geo_app_v2/config/appconfig.dart';
import 'package:geo_app_v2/ui/views/dashboard.dart';
import 'package:geo_app_v2/ui/views/login_page.dart';
import 'package:geo_app_v2/ui/views/view_profile.dart';
import 'package:geo_app_v2/ui/widgets/CustomBottomAppBar.dart';
import 'package:geo_app_v2/ui/widgets/NavDrawer.dart';
import 'package:geo_app_v2/ui/widgets/NotificationWidget.dart';
import 'package:geo_app_v2/ui/widgets/CustomRaisedToggleButton.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';



class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  static const String routeName = '/users';

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  bool _isLoading = false;
  bool _hasError = false;
  Map<String, dynamic>? _result;
  Map<String, dynamic>? _user;
  Map<String, String> roles = {
    "1": "Super Admin",
    "2": "Administrator",
    "3": "Coordinador",
    "4": "Seccional",
    "5": "Movilizador",
    "6": "Call Center",
    "7": "Familiar"
  };
  Map<String, Color> colorsByRole = {
    "1": Colors.white,
    "2": Colors.white,
    "3": const Color(0xAA00AE41),
    "4": const Color(0xFF26ad58),
    "5": const Color(0xFF6bcf8e),
    "7": const Color(0xFF84bf99)
  };

  List<dynamic>? _usersData;

  late AppModel model;

  @override
  void initState() {
    super.initState();

    model = ScopedModel.of<AppModel>(context);
    _isLoading = true;
    _hasError = false;
    _usersData = [];
    _initGettingData();
  }

  Future<void> _initGettingData() async {
    model.ifUserLoggedIn().then((result) {
      model.getLogedUser().then((user) {
        model.getUsers(user['id'].toString(), user['heirarchy_Id']).then((users) {
          List<dynamic> usersTmp = [];
          if (users != null && users['data'] != null) {
            for(var u in users['data']) {
              String id = u['id'].toString();
              String hid = u['heirarchy_Id'].toString();
              model.getUsersCount(id, hid).then((rlt) {
                u['childData'] = rlt['data'];
                u['expanded'] = false;
                usersTmp.add(u);
                if (users['data'].length == usersTmp.length) {
                  usersTmp.sort((a, b) => a["id"].compareTo(b["id"]));
                  setState(() {
                    _result = result;
                    _usersData = List.generate(usersTmp.length, (index) => usersTmp[index]);
                    _user = user;
                    _isLoading = false;
                  });
                }
              });
            }
            usersTmp.clear();
          } else {
            setState(() {
              _hasError = true;
              _isLoading = false;
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConfig.APP_COLOR,
        title: const Text(
          "Usuarios",
          textAlign: TextAlign.center,
        ),
        actions: const <Widget>[
          NotificationWidget(),
        ],
      ),
      body: _buildBody(),
      drawer: const NavDrawer(),
      bottomNavigationBar: CustomBottomAppBar(currentIndex: 1,),
    );
  }

  Widget _buildBody() {
    return _isLoading ? _buildLoader() : _buildContentWrapper();
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

  Widget _buildContentWrapper() {
    if (_result!["success"] == false) {
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    }
    // if (_hasError) {
    //   Navigator.pushReplacementNamed(context, Dashboard.routeName);
    // }
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return CupertinoScrollbar(
          thickness: 5,
          child: SingleChildScrollView(
            child: Center(
              child: _buildContent(),
            ),
          ),
          isAlwaysShown: false,
        );
      },
    );
  }

  Widget _buildContent() {
    return (_usersData!.isEmpty) ? _buildContentWithoutData() : _buildContentWithData();
  }

  Widget _buildContentWithoutData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const <Widget>[
            Icon(
              Icons.warning,
            ),
            Text(
              'No se encontraron usuarios',
              style: TextStyle(
                fontSize: 20.0,
                color: AppConfig.APP_DANGER_COLOR,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 5.0,
        ),
        const SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 25, right: 25),
            child: Center(
              child: Text(
                'Intenta ajustar los filtros de búsqueda.',
                style: TextStyle(

                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 25, right: 25),
            child: RaisedButton(
              textColor: Colors.white,
              color: AppConfig.APP_COLOR,
              child: const Text("Regresar a principal"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, Dashboard.routeName);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildContentWithData() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
      child: Material(
        color: Colors.white,
        elevation: 10.0,
        shadowColor: AppConfig.APP_WARNING_COLOR,
        borderRadius: const BorderRadius.all(
          Radius.circular(20.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHeaderSection(),
              const Divider(
                height: 1.0,
              ),
              _buildUsersSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  'Usuarios',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: AppConfig.APP_COLOR
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'GEO-VERDE',
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: RaisedButton.icon(
              icon: const Icon(Icons.filter),
              label: const Text('Filtro'),
              color: AppConfig.APP_COLOR,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              onPressed: () {

              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _usersData!.length,
        itemBuilder: (context, index) => _buildUserInfoWrapper(context, index),
        scrollDirection: Axis.vertical,
      ),
    );
  }

  Widget _buildUserInfoWrapper(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 5.0,
        right: 5.0,
      ),
      child: Card(
        color: (_usersData == null
            || _usersData![index] == null
            || _usersData![index]['childData'] == null
            || _usersData![index]['childData']['role'] == null ) ? Colors.white : colorsByRole[_usersData![index]['childData']['role'].toString()],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(15)
            )
        ),
        elevation: 14,
        shadowColor: Colors.blue,
        child: InkWell(
          splashColor: AppConfig.APP_COLOR.withAlpha(30),
          onTap: () async {
            // redirect to view profile
            SharedPreferences prefs = await SharedPreferences.getInstance();
            ScopedModel.of<AppModel>(context).getUserData(_usersData![index]['id'].toString())
                .then((selectedUser) {
              prefs.setString('selectedUser', json.encode(selectedUser));
              Navigator.of(context).pushNamed(ViewProfile.routeName);
            });
          },
          child: _buildUserInfo(context, index),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, int index) {
    return (_usersData == null
        || _usersData![index] == null
        || _usersData![index]['childData'] == null )
    ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Text('Can not Fetch Data'),
      ],
    ) : Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildUserCommonInfo(index),
        _buildUsersCntSection(index),
        _buildUserSeccionSection(index),
        _buildChildCnt(index),
        _buildViewMoreButtonWrapper(context, index),
      ],
    );
  }

  Widget _buildUserSeccionSection(int index) {
    return (_usersData![index]['childData']['role'].toString() == "4" ||
        _usersData![index]['childData']['role'].toString() == "5" ||
        _usersData![index]['childData']['role'].toString() == "7" ) ? Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Seccion - ',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          Text(
            _usersData![index]['childData']['seccion'].toString(),
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ],
      ),
    ) : Container();
  }

  Widget _buildUserCommonInfo(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(AppConfig.WEB_BASE_URL + _usersData![index]['image'])
                      )
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                  "${_usersData![index]['nombre']} - ${roles[_usersData![index]['role']]}"
              )
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Divider(
            height: 1.0,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget _buildUsersCntSection(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Usuarios Creados:',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal
            ),
          ),
          const SizedBox(
            width: 5.0,
          ),
          Text(
            (_usersData![index] == null
                || _usersData![index]['childData'] == null
                || _usersData![index]['childData']['users'] == null
            ) ? "Unknown" : _usersData![index]['childData']['users'].toString(),
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppConfig.APP_DANGER_COLOR
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildCnt(int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildAdminCnt(index),
          _buildCoordCnt(index),
          _buildSecciCnt(index),
          _buildMovilCnt(index),
          _buildFamilCnt(index),
        ],
      ),
    );
  }

  Widget _buildViewMoreButtonWrapper(BuildContext context, int index) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 10.0),
        child: _buildViewMoreButton(context, index),
      ),
    );
  }

  Widget _buildAdminCnt(int index) {
    return (_usersData![index]['childData']['admin_cnt'] == 0) ? Container()
        : Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Admin : ',
          style: TextStyle(
            fontSize: 12
          ),
        ),
        Text(
          _usersData![index]['childData']['admin_cnt'].toString(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(
          width: 10.0,
        )
      ],
    );
  }

  Widget _buildCoordCnt(int index) {
    return (_usersData![index]['childData']['coord_cnt'] == 0) ? Container()
        : Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Coord : ',
          style: TextStyle(
              fontSize: 12
          ),
        ),
        Text(
          _usersData![index]['childData']['coord_cnt'].toString(),
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(
          width: 10.0,
        )
      ],
    );
  }

  Widget _buildSecciCnt(int index) {
    return (_usersData![index]['childData']['secci_cnt'] == 0) ? Container()
        : Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'SL : ',
          style: TextStyle(
              fontSize: 12
          ),
        ),
        Text(
          _usersData![index]['childData']['secci_cnt'].toString(),
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(
          width: 10.0,
        )
      ],
    );
  }

  Widget _buildMovilCnt(int index) {
    return (_usersData![index]['childData']['movil_cnt'] == 0) ? Container()
        : Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'ML : ',
          style: TextStyle(
              fontSize: 12
          ),
        ),
        Text(
          _usersData![index]['childData']['movil_cnt'].toString(),
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(
          width: 10.0,
        )
      ],
    );
  }

  Widget _buildFamilCnt(int index) {
    return (_usersData![index]['childData']['famil_cnt'] == 0) ? Container()
        : Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'FL : ',
          style: TextStyle(
              fontSize: 12
          ),
        ),
        Text(
          _usersData![index]['childData']['famil_cnt'].toString(),
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(
          width: 3.0,
        )
      ],
    );
  }

  Widget _buildViewMoreButton(BuildContext context, int index) {
    return (_usersData![index]['childData']['users'] > 0) ? CustomRaisedButton(
      clickState: _usersData![index]['expanded'],
      onParentPressed:() async {
        setState(() {
          _isLoading = true;
        });
        String cId = _usersData![index]['id'].toString();
        String cHid = _usersData![index]['heirarchy_Id'].toString();
        if (_usersData![index]['expanded'] == false) {
          model.getUsers(cId, cHid).then((newChilds) {
            List<dynamic> newChildsTmp = [], tmpStation = [];
            if (newChilds != null && newChilds['data'] != null) {
              for(var nC in newChilds['data']) {
                String ncId = nC['id'].toString();
                String ncHid = nC['heirarchy_Id'].toString();
                model.getUsersCount(ncId, ncHid).then((ncInfo) {
                  nC['childData'] = ncInfo['data'];
                  nC['expanded'] = false;
                  newChildsTmp.add(nC);
                  if (newChilds['data'].length == newChildsTmp.length) {
                    newChildsTmp.sort((a, b) => a["id"].compareTo(b["id"]));
                    tmpStation = List.generate(_usersData!.length, (idx) => _usersData![idx]);
                    tmpStation.insertAll(index + 1, newChildsTmp);
                    setState(() {
                      _usersData = List.generate(tmpStation.length, (idx) => tmpStation[idx]);
                      _usersData![index]['expanded'] = true;
                      _isLoading = false;
                    });
                  }
                });
              }
            } else {
              setState(() {
                _hasError = true;
                _isLoading = false;
              });
            }
          });
        } else {
          String pattern = 'heirarchy_Id';
          setState(() {
            _usersData!.removeWhere(
                    (deletedUser) =>
                    (pattern + deletedUser['heirarchy_Id'].toString()).contains(pattern + cHid + '/'));
            _usersData![index]['expanded'] = false;
            _isLoading = false;
          });
        }
      },
    ) : RaisedButton.icon(
      icon: const Icon(Icons.hourglass_disabled_rounded),
      label: const Text('No More data'),
      color: AppConfig.APP_COLOR,
      textColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      onPressed: () {

      },
    );
  }

}
