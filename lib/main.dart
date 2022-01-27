// import 'package:adapty_flutter/models/adapty_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:recorder/Controllers/ProfileController.dart';
import 'package:recorder/Routes.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/Auth/Login.dart';
import 'package:recorder/UI/Auth/OldPerson.dart';
import 'package:recorder/UI/Home.dart';
import 'package:recorder/UI/Pages/Splash.dart';
import 'generated/l10n.dart';
import 'package:get/get.dart';

void main() {
  // InAppPurchaseConnection.enablePendingPurchases();
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ProfileController());
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: mainTheme,
      // home: Splash(),
      initialRoute: '/splash',
      // routes: <String, WidgetBuilder>{
      //   Routes.welcomeNew: (BuildContext context) => Login(),
      //   Routes.welcomeOld: (BuildContext context) => OldPerson(),
      //   Routes.home: (BuildContext context) => Home(),
      //   Routes.initial: (BuildContext context) => Splash(),
      // },
      getPages: [
        GetPage(
          name: '/login',
          page: () => Login(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/old',
          page: () => OldPerson(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/home',
          page: () => Home(),
          transition: Transition.downToUp,
          transitionDuration: Duration(milliseconds: 200)
        ),
        GetPage(
          name: '/splash',
          page: () => Splash(),
          transition: Transition.rightToLeft,
        ),
      ],
    );
  }
}
