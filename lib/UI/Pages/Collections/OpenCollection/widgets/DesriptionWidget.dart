import 'package:flutter/material.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/generated/l10n.dart';

class DescriptionWidget extends StatefulWidget {
  final String description;
  DescriptionWidget({@required this.description});
  @override
  _DescriptionWidgetState createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 28, right: 30),
      child: Column(
        children: [
          Text(
            widget.description,
            style: TextStyle(
                color: cBlack, fontSize: 14, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 9),
          Text(
            S.of(context).more_detailed,
            style: TextStyle(
                color: cBlack.withOpacity(0.5),
                fontSize: 13,
                fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
