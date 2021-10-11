import 'package:flutter/material.dart';
import 'package:recorder/models/AudioModel.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';

class ButtonPlay extends StatefulWidget {
  final Color colorPlay;
  final AudioItem item;
  final bool play;
  final Function onTap;

  ButtonPlay(
      {
        @required this.colorPlay,
        this.item,
        @required this.play,
        @required this.onTap
      });
  @override
  _ButtonPlayState createState() => _ButtonPlayState();
}

class _ButtonPlayState extends State<ButtonPlay> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap == null?null:widget.onTap();
      },
      // onLongPressStart: (i) {
      //   tap = true;
      //   setState(() {});
      // },
      // onLongPressEnd: (i) {
      //   tap = false;
      //   setState(() {});
      // },
      // onTapDown: (i) {
      //   tap = true;
      //   setState(() {});
      // },
      // onTapUp: (e) {
      //   tap = false;
      //   setState(() {});
      // },
      // onPanStart: (i) {
      //   tap = true;
      //   setState(() {});
      // },
      // onPanEnd: (e) {
      //   tap = false;
      //   setState(() {});
      // },
      child: IconSvg(
          widget.play
              ? widget.item.activeIcon
              : widget.item.inActiveIcon ?? widget.item.activeIcon,
          width: 50,
          height: 50,
          color: widget.colorPlay),
    );
  }
}
