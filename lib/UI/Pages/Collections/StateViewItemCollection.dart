import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/CollectionsState.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/widgets/Appbar.dart';
import 'package:provider/provider.dart';
import 'package:recorder/UI/widgets/AudioItem.dart';
import 'package:recorder/Utils/DropMenu/DropMenuItem.dart';
import 'package:recorder/Utils/DropMenu/FocusedMenuHolder.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:recorder/Utils/time/TimeParse.dart';
import 'package:recorder/models/AudioModel.dart';

class StateViewItemCollection extends StatefulWidget {
  @override
  _StateViewItemCollectionState createState() =>
      _StateViewItemCollectionState();
}

class _StateViewItemCollectionState extends State<StateViewItemCollection> {
  bool openDesc = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: cBlack.withOpacity(0.0),
        appBar: MyAppBar(
          buttonMore: false,
          buttonMenu: true,
          buttonBack: true,
          buttonAdd: false,
          buttonDone: false,
          padding: 10,
          top: 25,
          textRightButton: "Добавить",
          height: 90,
          tapLeftButton: () {
            context.read<GeneralController>().collectionsController.back();
          },
          childRight: FocusedMenuHolder(
              blurSize: 0,
              blurBackgroundColor: Colors.transparent,
              duration: Duration(milliseconds: 50),
              menuBoxDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15),
                  ),
              ),
              menuWidth: MediaQuery.of(context).size.width / 2,
              menuOffset: 10,
              menuItems: [
                FocusedMenuItem(
                  onPressed: () {
                    context
                        .read<GeneralController>()
                        .collectionsController
                        .edit();
                    context
                        .read<GeneralController>()
                        .createRouteOnEdit(currentPage: 1);
                  },
                  title: Text(
                    "Редактировать",
                    style: TextStyle(
                        color: cBlack,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        fontFamily: fontFamily),
                  ),
                ),
                FocusedMenuItem(
                  onPressed: () {
                    context
                        .read<GeneralController>()
                        .collectionsController
                        .selectSeveral();
                  },
                  title: Text(
                    "Выбрать несколько",
                    style: TextStyle(
                        color: cBlack,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        fontFamily: fontFamily),
                  ),
                ),
                FocusedMenuItem(
                  onPressed: () {
                    context
                        .read<GeneralController>()
                        .collectionsController
                        .deleteCurrent();
                  },
                  title: Text(
                    "Удалить подборку",
                    style: TextStyle(
                        color: cBlack,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        fontFamily: fontFamily),
                  ),
                ),
                FocusedMenuItem(
                  onPressed: () {}, //TODO share not written
                  title: Text(
                    "Поделиться",
                    style: TextStyle(
                        color: cBlack,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        fontFamily: fontFamily),
                  ),
                ),
              ],
              onPressed: () {},
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 11),
                child: Container(
                  width: 27,
                  height: 27,
                  child: Center(
                    child: IconSvg(IconsSvg.more,
                        width: 41, height: 8, color: cBackground),
                  ),
                ),
              )),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(14, 24, 14, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 4),
                child: _header(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(child: _image()),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
                child: _desc(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: _listAudio(),
              ),
            ],
          ),
        ),
    );
  }

  Widget _header() {
    return StreamBuilder<CollectionsState>(
        stream: context
            .read<GeneralController>()
            .collectionsController
            .streamCollections,
        builder: (context, snapshot) {
          return Text(
            snapshot.data?.currentItem?.name ?? "Подборка",
            style: TextStyle(
              color: cBackground,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: fontFamily,
            ),
          );
        });
  }

  Widget _image() {
    String timeInfo(Duration duration) {
      Duration all = duration;
      return "${all.toString().split(".").first.padLeft(8, "0")}";
    }

    return StreamBuilder<CollectionsState>(
        stream: context
            .read<GeneralController>()
            .collectionsController
            .streamCollections,
        builder: (context, snapshot) {
          print(snapshot.data?.currentItem ?? "No duration :(");
          return GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.15),
                      offset: Offset(8, 8),
                      blurRadius: 20,
                      spreadRadius: 4,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: Container(
                    width: MediaQuery.of(context).size.width - 32,
                    height: (MediaQuery.of(context).size.width - 32) * 240 / 382,
                    child: Stack(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width - 32,
                            height: (MediaQuery.of(context).size.width - 32) *
                                240 /
                                382,
                            child: snapshot.data?.currentItem?.picture == null
                                ? Image.asset(
                                    'assets/images/play.png',
                                    fit: BoxFit.cover,
                                  )
                                : snapshot.data.currentItem.isLocalPicture
                                    ? Image.file(
                                        File(snapshot.data.currentItem.picture),
                                        fit: BoxFit.cover,
                                      )
                                    : Image(
                                        image: NetworkImage(
                                            snapshot.data.currentItem.picture),
                                        fit: BoxFit.cover)),
                        Container(
                            width: MediaQuery.of(context).size.width - 32,
                            height: (MediaQuery.of(context).size.width - 32) *
                                240 /
                                382,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  Color.fromRGBO(0, 0, 0, 0),
                                  Color.fromRGBO(69, 69, 69, .05),
                                  Color.fromRGBO(69, 69, 69, .5)
                                ]))),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            child: Text(
                              snapshot.data?.currentItem?.publicationDate ?? "",
                              style: TextStyle(
                                  color: cBlack,
                                  fontFamily: fontFamily,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 30),
                            child: Text(
                              "${snapshot.data?.currentItem?.count} аудио\n${timeInfo(snapshot.data?.currentItem?.duration)}",
                              style: TextStyle(
                                  color: cBackground,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  fontFamily: fontFamily),
                            ),
                          ),
                        ),
                        snapshot.data?.currentItem?.playlist == null ||
                                snapshot.data?.currentItem?.playlist?.length == 0
                            ? SizedBox()
                            : Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 18),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      GestureDetector(
                                        behavior: HitTestBehavior.deferToChild,
                                        onTap: () {
                                          context
                                              .read<GeneralController>()
                                              .playerController
                                              .play(snapshot
                                                  .data.currentItem.playlist);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                245, 245, 245, 0.16),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                IconSvg(IconsSvg.play,
                                                    color: cBackground,
                                                    height: 38,
                                                    width: 38),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Запустить все",
                                                  style: TextStyle(
                                                    color: cBackground,
                                                    fontFamily: fontFamily,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                      ],
                    )),
              ),
            ),
          );
        });
  }

  Widget _desc() {
    return Container(
        child: StreamBuilder<CollectionsState>(
            stream: context
                .read<GeneralController>()
                .collectionsController
                .streamCollections,
            builder: (context, snapshot) {
              return !openDesc
                  ? GestureDetector(
                      behavior: HitTestBehavior.deferToChild,
                      onTap: () {
                        openDesc = true;
                        setState(() {});
                      },
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: 40,
                            maxHeight: 100,
                            minWidth: MediaQuery.of(context).size.width,
                            maxWidth: MediaQuery.of(context).size.width),
                        child: Text(
                          snapshot.data?.currentItem?.description ?? "",
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              color: cBlack,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              fontFamily: fontFamily),
                        ),
                      ),
                    )
                  : GestureDetector(
                      behavior: HitTestBehavior.deferToChild,
                      onTap: () {
                        openDesc = false;
                        setState(() {});
                      },
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: 40,
                            maxHeight: double.maxFinite,
                            minWidth: MediaQuery.of(context).size.width,
                            maxWidth: MediaQuery.of(context).size.width),
                        child: Text(
                          snapshot.data.currentItem.description ?? "",
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              color: cBlack,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              fontFamily: fontFamily),
                        ),
                      ),
                    );
            }));
  }

  Widget _listAudio() {
    return StreamBuilder<CollectionsState>(
        stream: context
            .read<GeneralController>()
            .collectionsController
            .streamCollections,
        builder: (context, snapshot) {
          List<AudioItem> list = snapshot.data?.currentItem?.playlist ?? [];
          return list == [] || list.length == 0
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "Нет аудиозаписей",
                      style: TextStyle(
                          color: cBlack.withOpacity(0.4),
                          fontFamily: fontFamily,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                )
              : Container(
                  child: Column(
                  children: List.generate(
                    list.length,
                    (index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: AudioItemWidget(
                              colorPlay: cSwamp,
                              selected: false,
                              item: list[index],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ));
        });
  }
}
