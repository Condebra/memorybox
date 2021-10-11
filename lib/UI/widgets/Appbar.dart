import 'package:flutter/material.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';

const double appbarHeight = 56.0;

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool buttonMore;
  final bool buttonMenu;
  final bool buttonBack;
  final bool buttonAdd;
  final bool buttonDone;
  final double height;
  final Widget child;
  final double padding;
  final double top;
  final Function tapLeftButton;
  final Function tapRightButton;
  final String textRightButton;
  final Widget childRight;

  MyAppBar({
    this.buttonMore = false,
    this.buttonBack = true,
    this.buttonMenu = true,
    this.buttonAdd = false,
    this.buttonDone = false,
    this.height = 64,
    this.child,
    this.padding = 5,
    this.top = 0,
    this.tapLeftButton,
    this.tapRightButton,
    this.textRightButton,
    this.childRight
  });

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: widget.padding, right: widget.padding, top: widget.top),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.buttonBack
                ? InkWell(
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              enableFeedback: false,
                    onTap: () {
                      if(widget.tapLeftButton != null){
                        widget.tapLeftButton();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: cBackground,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: IconSvg(IconsSvg.back, width: 27, height: 27),
                      ),
                    ),
                  )
                : widget.buttonMenu
                    ? Container(
                        child: InkWell(
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            enableFeedback: false,
                            onTap: () {
                              if(widget.tapLeftButton != null){
                                widget.tapLeftButton();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 11),
                              child: Container(
                                width: 27,
                                height: 27,
                                child: IconSvg(IconsSvg.menu,
                                    width: 28, height: 21, color: cBackground),
                              ),
                            )),
                      )
                    : widget.buttonAdd?Container(
              child: GestureDetector(
                  behavior: HitTestBehavior.deferToChild,
                  onTap: () {
                    if(widget.tapLeftButton != null){
                      widget.tapLeftButton();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 11),
                    child: Container(
                      width: 27,
                      height: 27,
                      child: IconSvg(IconsSvg.add,
                          width: 28, height: 21, color: cBackground),
                    ),
                  )),
            ):SizedBox(),
            widget.child != null ? widget.child : SizedBox(),
            widget.childRight != null?widget.childRight:widget.buttonMore
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 11),
                    child: Container(
                      width: 27,
                      height: 27,
                      child: Center(
                        child: GestureDetector(
                          behavior: HitTestBehavior.deferToChild,
                            onTap: () {
                              widget.tapRightButton == null?null:widget.tapRightButton();
                            },
                            child: IconSvg(IconsSvg.more,
                                width: 41, height: 8, color: cBackground),
                        ),
                      ),
                    ),
                  )
                : widget.buttonDone?GestureDetector(
                behavior: HitTestBehavior.deferToChild,
                onTap: () {
                  widget.tapRightButton == null?null:widget.tapRightButton();
                },
                child: Center(child: Text(widget.textRightButton??"Готово", style: TextStyle(color: cBackground, fontSize: 16, fontFamily: fontFamily),))): SizedBox(
                    width: 28,
                  )
          ],
        ),
      ),
    );
  }
}
