import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:recorder/Routes.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/Auth/Login.dart';
import 'package:recorder/UI/Auth/OldPerson.dart';
import 'package:recorder/UI/General.dart';
import 'package:recorder/UI/Pages/Splash.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'generated/l10n.dart';

void main() {
  InAppPurchaseConnection.enablePendingPurchases();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: mainTheme,
      home: Splash(),
      initialRoute: Routes.initial,
      routes: <String, WidgetBuilder>{
        Routes.welcomeNew: (BuildContext context) => Login(),
        Routes.welcomeOld: (BuildContext context) => OldPerson(),
        Routes.home: (BuildContext context) => General(),
        Routes.initial: (BuildContext context) => Splash(),
      },
    );
  }
}
