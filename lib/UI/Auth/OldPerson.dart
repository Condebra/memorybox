import 'package:flutter/material.dart';
import 'package:recorder/Controllers/LoginController.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/widgets/Background.dart';
import 'package:recorder/UI/widgets/DefaultTitle.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:recorder/Utils/app_keys.dart';
import 'package:recorder/generated/l10n.dart';

class OldPerson extends StatefulWidget {
  @override
  _OldPersonState createState() => _OldPersonState();
}

class _OldPersonState extends State<OldPerson> {
  LoginController controller;

  goHome()async{
    // await Future.delayed(Duration(milliseconds: 2));
    controller.transitionToHome();

  }

  @override
  void initState() {
    super.initState();
    controller = LoginController();
    goHome();
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      child: Scaffold(
        key: AppKeys.scaffoldKeyAuthOld,
        body: Container(
          color: Theme.of(context).backgroundColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Background(title: DefaultTitle(), body: body()),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
              color: cBackground,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 7,
                    spreadRadius: 0,
                    color: Color.fromRGBO(0, 0, 0, 0.11))
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 21),
            child: Text(
              S.of(context).hello_old,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily,
                  fontSize: 24,
                  color: cBlack),
            ),
          ),
        ),
        IconSvg(IconsSvg.heart, width: 45, color: cOrange),
        SizedBox(),
        SizedBox(),
        Container(
          decoration: BoxDecoration(
              color: cBackground,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 7,
                    spreadRadius: 0,
                    color: Color.fromRGBO(0, 0, 0, 0.11))
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 21),
            child: Text(
              S.of(context).hello_old_desc,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily,
                  fontSize: 14,
                  color: cBlack),
            ),
          ),
        ),
      ],
    );
  }
}
