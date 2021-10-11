import 'package:flutter/material.dart';

String fontFamily = "TT";
String fontFamilyMedium = "TTmedium";

/////////////////////////////////// ---- PROFILE PAGE ---- ///////////////////////////////
TextStyle nameTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: cBlack,
    fontFamily: 'TTmedium');

TextStyle phoneTextStyle({@required bool isPhone}) {
  return isPhone
      ? TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: cBlack)
      : TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: cBlack);
}

TextStyle subscriptionTextStyle =
    TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: cBlack);

TextStyle bottomProfileTextStyle({@required bool isLogOut}) {
  return isLogOut
      ? TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: cBlack)
      : TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: cRed);
}

//////////////////////////////////////////////////////////////////////////////////////////
///
///
const Color cBlack = Color.fromRGBO(58, 58, 85, 1);
const Color cYellow = Color.fromRGBO(255, 218, 121, 1);
const Color cRed = Color.fromRGBO(226, 119, 119, 1);
const Color cGreen = Color.fromRGBO(121, 166, 113, 1);
const Color cOrange = Color.fromRGBO(241, 180, 136, 1);
const Color cBlue = Color.fromRGBO(94, 119, 206, 1);
const Color cBlueSoso = Color.fromRGBO(140, 132, 226, 1);
const Color cBackground = Color.fromRGBO(246, 246, 246, 1);
const Color cSwamp = Color.fromRGBO(113, 165, 159, 1);

ThemeData mainTheme =
    ThemeData.dark().copyWith(backgroundColor: cBackground, focusColor: cBlue);
