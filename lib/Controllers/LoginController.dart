import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Routes.dart';
import 'package:recorder/Utils/tokenDB.dart';
import 'package:recorder/models/Put.dart';
import 'package:recorder/Rest/Auth/AuthProvider.dart';
import 'package:recorder/UI/General.dart';
import 'package:recorder/Utils/app_keys.dart';

class LoginController {
  PageController controllerPages = PageController(initialPage: 0);
  GeneralController generalController = GeneralController();

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

  stepTwoTap(BuildContext context) async {
    if (maskFormatter.getUnmaskedText().length == 10) {
      controllerPages.animateToPage(2,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
      getCode();
    } else
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Номер телефона слишком короткий"),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  stepThreeTap(BuildContext context) async {
    if (maskFormatterCode.getUnmaskedText().length == 4) {
      Put response = await AuthProvider.checkCode(
          "7${maskFormatter.getUnmaskedText()}",
          maskFormatterCode.getUnmaskedText());
      if (response.code == 200) {
        controllerPages.animateToPage(3,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
        checkCode();
        await Future.delayed(
            Duration(milliseconds: 700)); //wtf is that? why are we waiting?
        pushHome(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Неправильный код"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        controllerCode.text = "";
      }
    } else
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Код слишком короткий"),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  futureAuthSet(bool state, {BuildContext restartContext}) async {
    await futureAuth(state: state);
    print(state);
    if (restartContext != null) {
      Navigator.pushReplacementNamed(restartContext, Routes.initial);
    }
  }

  transitionToHome() async {
    await Future.delayed(Duration(milliseconds: 800));
    pushHome(AppKeys.scaffoldKeyAuthOld.currentContext);
  }

  getCode() async {
    AuthProvider.sendCode("7${maskFormatter.getUnmaskedText()}");
  }

  checkCode() async {} //todo checking codes

  pushHome(BuildContext context) {
    // generalController.setPage(0);
    Navigator.pushAndRemoveUntil(
        context, routeHome(), (Route<dynamic> route) => false);
  }

  Route routeHome() {
    var curve = Curves.ease;
    var curveTween = CurveTween(curve: curve);

    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 400),
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
