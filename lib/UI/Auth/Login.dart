import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:recorder/Controllers/LoginController.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/widgets/Background.dart';
import 'package:recorder/UI/widgets/ButtonOrange.dart';
import 'package:recorder/UI/widgets/DefaultTitle.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:recorder/Utils/app_keys.dart';
import 'package:recorder/generated/l10n.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginController controller;

  @override
  void initState() {
    super.initState();
    controller = LoginController();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Theme.of(context).backgroundColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          key: AppKeys.scaffoldKeyAuth,
          body: SingleChildScrollView(child: Background(title: DefaultTitle(), body: body())),
        ),
      ),
    );
  }

  Widget body() {
    return PageView(
      physics: BouncingScrollPhysics(),
      // allowImplicitScrolling: true,
      controller: controller.controllerPages,
      children: [stepOne(), stepTwo(), stepThree(), stepFour()],
    );
  }

  Widget stepOne() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              S.of(context).hello_new1,
              style: TextStyle(
                  color: cBlack,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily,
                  fontSize: 24),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              S.of(context).hello_new2,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: cBlack,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily,
                  fontSize: 16),
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ),
        ButtonOrange(
          onTap: () {
            controller.stepOneTap();
          },
          text: S.of(context).btn_next,
        ),
        SizedBox(),
        SizedBox(),
      ],
    );
  }

  Widget stepTwo() {
    return Padding(
      padding: const EdgeInsets.only(left:12.0, right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                S.of(context).enter_num,
                style: TextStyle(
                    color: cBlack,
                    fontWeight: FontWeight.w400,
                    fontFamily: fontFamily,
                    fontSize: 14),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: cBackground,
                      borderRadius: BorderRadius.all(Radius.circular(41)),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 11,
                          spreadRadius: 0,
                          color: Color.fromRGBO(0, 0, 0, 0.17),
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: controller.controllerNum,
                      inputFormatters: [controller.maskFormatter],
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: cBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                      decoration: InputDecoration(
                        alignLabelWithHint: false,
                        border: InputBorder.none,
                        // prefix: Text('+7 '),

                        filled: true,
                        hintText: "+7 (900) 000-00-00",
                        hintStyle: TextStyle(
                          color: Colors.black45,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          Column(
            children: [
              ButtonOrange(
                  onTap: () {
                    controller.stepTwoTap();
                  },
                  text: S.of(context).btn_next),
              SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: (){
                  controller.futureAuthSet(true, restartContext: context);
                },
                child: Text(
                  S.of(context).later,
                  style: TextStyle(
                      color: cBlack,
                      fontSize: 24,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
                color: cBackground,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 7,
                    spreadRadius: 0,
                    color: Color.fromRGBO(0, 0, 0, 0.11),
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                S.of(context).desc_register,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: cBlack,
                    fontWeight: FontWeight.w400,
                    fontFamily: fontFamily,
                    fontSize: 14),
              ),
            ),
          ),
          SizedBox()
        ],
      ),
    );
  }

  Widget stepThree() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                S.of(context).enter_code,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: cBlack,
                    fontWeight: FontWeight.w400,
                    fontFamily: fontFamily,
                    fontSize: 14),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: cBackground,
                      borderRadius: BorderRadius.all(Radius.circular(41)),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 11,
                          spreadRadius: 0,
                          color: Color.fromRGBO(0, 0, 0, 0.17),
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: controller.controllerCode,
                      inputFormatters: [controller.maskFormatterCode],
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: cBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                      decoration: InputDecoration(
                        alignLabelWithHint: false,
                        border: InputBorder.none,
                        // prefix: Text('+7 '),

                        filled: true,
                        hintText: "Код",
                        hintStyle: TextStyle(
                          color: Colors.black45,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              ButtonOrange(
                  onTap: () {
                    controller.stepThreeTap();
                  },
                  text: S.of(context).btn_next),
              Text(
                "",
                style: TextStyle(
                    color: cBlack,
                    fontSize: 24,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
                color: cBackground,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 7,
                    spreadRadius: 0,
                    color: Color.fromRGBO(0, 0, 0, 0.11),
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                S.of(context).desc_register,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: cBlack,
                    fontWeight: FontWeight.w400,
                    fontFamily: fontFamily,
                    fontSize: 14),
              ),
            ),
          ),
          SizedBox()
        ],
      ),
    );
  }

  Widget stepFour() {
    return Column(
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
                  color: Color.fromRGBO(0, 0, 0, 0.11),
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: Text(
              S.of(context).hello_old,
              style: TextStyle(
                  color: cBlack,
                  fontSize: 24,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        SizedBox(
          height: 70,
        ),
        IconSvg(IconsSvg.heart, width: 45, color: cOrange),
      ],
    );
  }

  Widget buttonNext({Function onTap}) {
    return GestureDetector(
      onTap: () {
        onTap() ?? null;
      },
      child: Container(
        decoration: BoxDecoration(
            color: cOrange,
            borderRadius: BorderRadius.all(Radius.circular(51))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 16),
          child: Text(
            S.of(context).btn_next,
            style: TextStyle(
              color: cBackground,
              fontSize: 18,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
