// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:geo_app_v2/config/appconfig.dart';


class CustomRaisedButton extends StatefulWidget {

  final Function onParentPressed;
  final bool clickState;
  const CustomRaisedButton(
      {
        Key? key,
        required this.onParentPressed,
        required this.clickState,
      }
    ) : super(key: key);

  @override
  State<CustomRaisedButton> createState() => _CustomRaisedButtonState();
}

class _CustomRaisedButtonState extends State<CustomRaisedButton> {

  bool _isClicked = false;
  late Function _onParentPressed;



  @override
  void initState() {
    super.initState();
    _isClicked = widget.clickState;
    _onParentPressed = widget.onParentPressed;
  }

  @override
  Widget build(BuildContext context) {
    return !_isClicked ? RaisedButton.icon(
      icon: const Icon(Icons.add_circle),
      label: const Text('View Child Members'),
      color: AppConfig.APP_COLOR,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      onPressed: () {
        _onParentPressed();
        setState(() {
          _isClicked = !_isClicked;
        });
      },
    ) : RaisedButton.icon(
      icon: const Icon(Icons.arrow_back_ios),
      label: const Text('Hide Child Members'),
      color: AppConfig.APP_WARNING_COLOR,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      onPressed: () {
        setState(() {
          _onParentPressed();
          _isClicked = !_isClicked;
        });
      },
    );
  }
}
