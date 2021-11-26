import 'package:flutter/material.dart';

class FocusedMenuItem {
  Color backgroundColor;
  Widget title;
  Widget iconCustom;
  Icon trailingIcon;
  Function onPressed;

  FocusedMenuItem(
      {this.backgroundColor,
        @required this.title,
        this.trailingIcon,
        this.iconCustom,
        @required this.onPressed});
}