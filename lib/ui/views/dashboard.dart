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
import 'package:syncfusion_flutter_charts/charts.dart';


class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  static const String routeName = '/dashboard';

  @override
  State<StatefulWidget> createState() {
    return _Dashboard();
  }
}

class _Dashboard extends State<Dashboard> {
  bool _isLoading = false;
  Map<String, dynamic>? _result;
  Map<String, dynamic>? _data;
  Map<String, dynamic>? _user;

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
      });
    });
    ScopedModel.of<AppModel>(context).getLogedUser().then((user) {
      setState(() {
        _user = user;
      });
    });
    ScopedModel.of<AppModel>(context).getDashboardData().then((result) {
      setState(() {
        _data = result['data'];
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
            title: const Text(
              "Dashboard",
              textAlign: TextAlign.center,
            ),
            actions: const <Widget>[
              NotificationWidget(),
            ],
          ),
          body: _buildBody(),
          drawer: const NavDrawer(),
          bottomNavigationBar: CustomBottomAppBar(currentIndex: 0,),
        );
      },
    );
  }

  Widget _buildBody() {
    return _isLoading ? _buildLoader() : _buildDashboard();
  }

  Widget _buildDashboard() {
    if (_result!["success"] == false) {
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    }
    if (_result!["data"].length == 0) {
      return const Center(
        child: Text('No data'),
      );
    } else {
      return CupertinoScrollbar(
        thickness: 5,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildGreetingWidget(),
                _buildSatisUserWidget(),
              ],
            ),
          ),
        ),
        isAlwaysShown: false,
      );
    }
  }

  Widget _buildGreetingWidget() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30,
        bottom: 5,
        left: 10,
        right: 10
      ),
      child: Material(
          color: Colors.white,
          elevation: 4.0,
          borderRadius: const BorderRadius.all(
            Radius.circular(20.0),
          ),
          shadowColor: Colors.black87,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildGreetingText(),
              _buildUserAvatar(),
            ],
          ),
      )
    );
  }

  Widget _buildGreetingText() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Welcome!',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Hi, ${_user!['nombre']}",
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 10),
      child: Center(
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(AppConfig.WEB_BASE_URL + _user!['image']),
                )
            ),
          )
      ),
    );
  }

  Widget _buildSatisUserWidget() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 10,
        right: 10
      ),
      child: Material(
          color: Colors.white,
          elevation: 3.0,
          borderRadius: const BorderRadius.all(
            Radius.circular(20.0),
          ),
          shadowColor: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 20,
              left: 10,
              right: 10
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _buildUserCntWidget(),
                const SizedBox(
                  height: 15.0,
                ),
                _buildChartDescriptionWidget(),
                _buildChartWidget(),
              ],
            ),
          ),
      ),
    );
  }

  Widget _buildChartDescriptionWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Gráfico General',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Se muestra el total de usuarios por categoría'),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget _buildChartWidget() {
    return Center(
        child: SfCartesianChart(
          // Initialize category axis
            primaryXAxis: CategoryAxis(),
            series: <LineSeries<SalesData, String>>[
              LineSeries<SalesData, String>(
                // Bind data source
                  dataSource:  <SalesData>[
                    SalesData('AD', double.parse("${_data!['userGroupByRole']['Admin'] ?? 0  }")),
                    SalesData('CO', double.parse("${_data!['userGroupByRole']['Coordinador'] ?? 0 }")),
                    SalesData('SE', double.parse("${_data!['userGroupByRole']['Seccional'] ?? 0 }")),
                    SalesData('MV', double.parse("${_data!['userGroupByRole']['Movilizador'] ?? 0 }")),
                    SalesData('FL', double.parse("${_data!['userGroupByRole']['Familiar'] ?? 0  }" )),
                    SalesData('CA', double.parse("${_data!['userGroupByRole']['Call Center'] ?? 0 }"))
                  ],
                  xValueMapper: (SalesData sales, _) => sales.year,
                  yValueMapper: (SalesData sales, _) => sales.sales,
                  dataLabelSettings: DataLabelSettings(isVisible: true)
              )
            ]
        )
    );
  }

  Widget _buildUserCntWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Material(
          color: Colors.white,
          elevation: 5.0,
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          shadowColor: Colors.green,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Usuarios en tu lista",
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    (_data == null
                        || _data!['totalUser'] == null) ? "Unknown" : "${_data!['totalUser']}",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Material(
          color: Colors.white,
          elevation: 5.0,
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          shadowColor: Colors.purple,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Agregados por ti",
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    (_data == null
                        || _data!['userAddedBySelf'] == null) ? "Unknown" : "${_data!['userAddedBySelf']}",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Material(
          color: Colors.white,
          elevation: 5.0,
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          shadowColor: Colors.pink,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Agregados última semana",
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    (_data == null
                        || _data!['totalUserInLast7Days'] == null ) ? "Unknown" : "${_data!['totalUserInLast7Days']}",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Material(
          color: Colors.white,
          elevation: 5.0,
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          shadowColor: Colors.amber,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Agregados por ti, última semana",
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    (_data == null
                        || _data!['userAddedSelfInLast7Days'] == null) ? "Unknown" : "${_data!['userAddedSelfInLast7Days']}",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
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

}
