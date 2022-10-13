import 'package:flutter/material.dart';
import 'package:geo_app_v2/config/appconfig.dart';
// import 'package:scoped_model/scoped_model.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({Key? key}) : super(key: key);

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {

  bool _isClicked = false;

  @override
  void initState() {
    _isClicked = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: IconButton(
        icon: Icon(
          Icons.notifications,
          color: _isClicked ? AppConfig.APP_WARNING_COLOR : Colors.white,
        ),
        onPressed: () {
          setState(() {
            _isClicked = !_isClicked;
          });
        },
      ),
    );
  }
}
