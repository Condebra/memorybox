import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/generated/l10n.dart';
import 'package:recorder/models/CollectionModel.dart';

class SmallCollectionItem extends StatefulWidget {
  String img;
  String title;
  int audioQuantity;
  String timeOfCollection;
  int length;
  Color contColor;
  Function onTap;
  String text;
  final CollectionItem item;

  SmallCollectionItem(
      {this.img,
      this.title,
      this.audioQuantity,
      this.timeOfCollection,
      @required this.text,
      @required this.length,
      @required this.contColor,
      @required this.onTap,
      @required this.item});

  @override
  _SmallCollectionItemState createState() => _SmallCollectionItemState();
}

class _SmallCollectionItemState extends State<SmallCollectionItem> {
  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    width = (MediaQuery.of(context).size.width / 2 - 43 / 2);
    height = (MediaQuery.of(context).size.width / 2 - 43 / 2) * 113 / 183;

    return widget.text != null
        ? GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () {
              widget.onTap == null ? null : widget.onTap();
            },
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: widget.contColor),
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(bottom: 1.5),
                  decoration: BoxDecoration(
                      border: widget.length == 0
                          ? null
                          : Border(
                              bottom:
                                  BorderSide(color: cBackground, width: 1))),
                  child: Text(
                    "${widget.text}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
            ),
          )
        : GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () {
              widget.onTap == null ? null : widget.onTap();
            },
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
                    padding: const EdgeInsets.symmetric(
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
                                  Text("${widget.audioQuantity} аудио",
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
                    ))
              ]),
            ));
  }
}
