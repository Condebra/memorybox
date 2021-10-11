import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recorder/Routes.dart';
import 'package:recorder/Utils/tokenDB.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  initHome()async{
    String token = await tokenDB();
    if(token == "null" && !await futureAuth()){
      Navigator.pushNamedAndRemoveUntil(context, Routes.welcomeNew,(Route<dynamic> route) => false);
    }else{
      Navigator.pushNamedAndRemoveUntil(context, Routes.welcomeOld,(Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    initHome();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
