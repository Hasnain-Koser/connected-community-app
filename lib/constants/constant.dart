import 'package:flutter/material.dart';

InputDecoration textInputDecor = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
  focusedBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 2)),
);

Widget getIcon(String type, Color color) {
  type = type.toLowerCase();
  Map<String, Widget> myIcons = {
    'service': Icon(
      Icons.engineering,
      color: color,
    ),
    'festival': Icon(
      Icons.festival,
      color: color,
    ),
    'community': Icon(
      Icons.group,
      color: color,
    ),
    'construction': Icon(
      Icons.handyman,
      color: color,
    ),
  };
  return myIcons[type];
}
