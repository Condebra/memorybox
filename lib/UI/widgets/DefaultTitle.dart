import 'package:flutter/material.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/generated/l10n.dart';

class DefaultTitle extends StatefulWidget {
  @override
  _DefaultTitleState createState() => _DefaultTitleState();
}

class _DefaultTitleState extends State<DefaultTitle> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: S.of(context).app_name,
          style: TextStyle(
              fontSize: 48,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w700),
          children: [
            TextSpan(
                text: "\n${S.of(context).slogan}",
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w400))
          ]),
      textAlign: TextAlign.end,
    );
  }
}
