import 'package:flutter/material.dart';
import 'package:recorder/Style.dart';

class ProgressBar extends StatefulWidget {
  double width;
  double height;
  int usage;
  int available;
  ProgressBar(
      {@required this.width,
      @required this.height,
      @required this.usage,
      @required this.available});
  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(color: cBlack, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
            width: widget.width,
            height: widget.height,
            child: Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: widget.height,
                  width: ((widget.usage / widget.available) * widget.width)
                      .toDouble(),
                  decoration: BoxDecoration(
                      color: cOrange,
                      borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
