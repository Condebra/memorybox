import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:recorder/Routes.dart';
import 'package:recorder/Utils/tokenDB.dart';
import 'package:recorder/models/Put.dart';
import 'package:recorder/Rest/Auth/AuthProvider.dart';
import 'package:recorder/UI/General.dart';
import 'package:recorder/Utils/app_keys.dart';

class LoginController {
  PageController controllerPages = PageController(initialPage: 0);

  var maskFormatter = new MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});
  var maskFormatterCode = new MaskTextInputFormatter(
      mask: '# # # #', filter: {"#": RegExp(r'[0-9]')});
  TextEditingController controllerNum = TextEditingController();
  TextEditingController controllerCode = TextEditingController();

  stepOneTap() {
      controllerPages.animateToPage(1,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  stepTwoTap() async {
    if (maskFormatter.getUnmaskedText().length == 10) {
        controllerPages.animateToPage(2,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
        getCode();
    }
  }

  stepThreeTap() async {
    if (maskFormatterCode.getUnmaskedText().length == 4) {
      Put response = await AuthProvider.checkCode(
          "7${maskFormatter.getUnmaskedText()}",
          maskFormatterCode.getUnmaskedText());
      if (response.error == 200) {
        controllerPages.animateToPage(3,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
        checkCode();
        await Future.delayed(Duration(milliseconds: 700));
        pushHome(AppKeys.scaffoldKeyAuth.currentContext);
      } else {
        controllerCode.text = "";
      }
    }
  }

  futureAuthSet(bool state, {BuildContext restartContext})async{
    await futureAuth(state: state);
    if(restartContext != null){
      Navigator.pushReplacementNamed(restartContext, Routes.initial);
    }
  }



  transitionToHome() async {
    await Future.delayed(Duration(seconds: 2, milliseconds: 500));
    pushHome(AppKeys.scaffoldKeyAuthOld.currentContext);
  }

  getCode() async {
    AuthProvider.sendCode("7${maskFormatter.getUnmaskedText()}");
  }

  checkCode() async {}


  pushHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(context, routeHome(), (Route<dynamic> route) => false);
  }

  Route routeHome() {
    var curve = Curves.ease;
    var curveTween = CurveTween(curve: curve);

    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 2500),
      pageBuilder: (context, animation, secondaryAnimation) => General(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
          reverseCurve: curve,
        );
        return SlideTransition(
          // position: offsetAnimation,
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}
