import 'package:flutter/material.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/generated/l10n.dart';

class ButtonOrange extends StatefulWidget {
  final Function onTap;
  final String text;
  ButtonOrange({this.onTap, @required this.text});
  @override
  _ButtonOrangeState createState() => _ButtonOrangeState();
}

class _ButtonOrangeState extends State<ButtonOrange> {
  bool longTap = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap != null ? widget.onTap() : null;
      },
      onLongPressStart: (i) {
        longTap = true;
        setState(() {});
      },
      onLongPressEnd: (i) {
        longTap = false;
        setState(() {});
      },
      onTapDown: (i) {
        longTap = true;
        setState(() {});
      },
      onTapUp: (e) {
        longTap = false;
        setState(() {});
      },
      onPanStart: (i) {
        longTap = true;
        setState(() {});
      },
      onPanEnd: (e) {
        longTap = false;
        setState(() {});
      },
      child: AnimatedPadding(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
            horizontal: longTap ? 2 : 0, vertical: longTap ? 1 : 0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
              color: cOrange,
              borderRadius: BorderRadius.all(Radius.circular(51))),
          child: AnimatedPadding(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
                horizontal: 75 - (longTap ? 2 : 0).toDouble(),
                vertical: 16 - (longTap ? 1 : 0).toDouble()),
            child: Text(
              widget.text,
              // S.of(context).btn_next,
              style: TextStyle(
                color: cBackground,
                fontSize: 18,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
