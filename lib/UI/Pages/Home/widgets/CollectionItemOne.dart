import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recorder/Style.dart';

import 'package:recorder/generated/l10n.dart';
import 'package:recorder/models/CollectionModel.dart';

class CollectionItemOne extends StatefulWidget {
  CollectionItem item;
  Function onTap;
  String title;

  CollectionItemOne({this.title, @required this.item, @required this.onTap});

  _CollectionItemOneState createState() => _CollectionItemOneState();
}

class _CollectionItemOneState extends State<CollectionItemOne> {
  bool longTap = false;

  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    width = (MediaQuery.of(context).size.width / 2 - 43 / 2);
    height = ((MediaQuery.of(context).size.width / 2 - 43 / 2)) * 240 / 183;

    return widget.title != null
        ? GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap();
              }
            },
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 20,
                      color: Color.fromRGBO(0, 0, 0, 0.15))
                ],
                borderRadius: BorderRadius.circular(15),
                color: Color.fromRGBO(113, 165, 159, 0.8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      S.of(context).titleOfEmptyCollection,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        // letterSpacing: 1.01
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 1.5),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: cBackground, width: 1))),
                        child: Text(
                          S.of(context).add,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap();
              }
            },
            onLongPressStart: (i) {
              longTap = true;
              setState(() {});
            },
            onLongPressEnd: (i) {
              longTap = false;
              if (widget.onTap != null) {
                widget.onTap();
              }
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
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.20),
                    offset: Offset(8, 8),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(alignment: Alignment.bottomLeft, children: [
                  Container(
                    width: width,
                    height: height,
                    color: cBlack,
                    child: widget.item.picture == null
                        ? Image.asset(
                            'assets/images/play.png',
                            fit: BoxFit.cover,
                          )
                        : widget.item.isLocalPicture
                            ? Image.file(
                                File(widget.item.picture),
                                fit: BoxFit.cover,
                              )
                            : Image(
                                image: NetworkImage(widget.item.picture),
                                fit: BoxFit.cover),
                  ),
                  Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Color.fromRGBO(0, 0, 0, 0),
                          Color.fromRGBO(69, 69, 69, .05),
                          Color.fromRGBO(69, 69, 69, .5)
                        ])),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 13.0, vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width / 2.3,
                                child: Text("${widget.item.name}",
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                              ),
                              Container(
                                width: width / 2.4,
                                alignment: Alignment.bottomRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text("${widget.item.count} аудио",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400)),
                                    Text("${widget.item.duration.inHours} часа",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      )),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: longTap ? 0.2 : 0.0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 240 / 896,
                      width: MediaQuery.of(context).size.width * 183 / 414,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  )
                ]),
              ),
            ));
  }
}
