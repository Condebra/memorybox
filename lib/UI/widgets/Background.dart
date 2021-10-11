import 'package:flutter/material.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';

class Background extends StatefulWidget {
  final Widget title;
  final Widget body;
  final Color color;
  Background({this.body, this.title, this.color});

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 414 / 369,
                        child: IconSvg(IconsSvg.backEllipse,
                            width: MediaQuery.of(context).size.width,
                            color: widget.color == null ? cBlueSoso : widget.color),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.width*369/414),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 414 / 369,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: widget.title ?? SizedBox(),
                    ),
                  ),
                ),

              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child:   Container(
                height: MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).size.width * 369 / 414),
                child: widget.body ?? SizedBox()),
          )

        ],
      ),
    );
  }
}
