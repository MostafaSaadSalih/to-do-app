// Flutter imports:
import 'package:flutter/material.dart';

import '../theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, this.theFunction, this.label, this.icon, this.dialogButtons}) : super(key: key);
  final Function()? theFunction;
  final String? label;
  final icon;
  final dialogButtons;


  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton.icon(
          onPressed: theFunction,
          icon:icon==null? Container(): icon,
          label: Text(label!),
        style: ElevatedButton.styleFrom(
          primary: primaryClr,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // <-- Radius
          ),
        ),
      ),
    );
  }
}
