import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/CollectionsState.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/widgets/Appbar.dart';
import 'package:provider/provider.dart';
import 'package:recorder/UI/widgets/AudioItem.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:recorder/models/AudioItem.dart';

class StateAddCollection extends StatefulWidget {
  @override
  _StateAddCollectionState createState() => _StateAddCollectionState();
}

class _StateAddCollectionState extends State<StateAddCollection> {
  bool editHeader = false;
  bool editComment = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // context.read<GeneralController>().collectionsController.controllerHeader.addListener(() {
    //   name = context.read<GeneralController>().collectionsController.controllerHeader.text;
    //   setState(() {});
    // });
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        editHeader = false;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBlack.withOpacity(0.0),
      appBar: MyAppBar(
        buttonMore: false,
        buttonMenu: false,
        buttonBack: true,
        buttonAdd: false,
        buttonDone: true,
        padding: 10,
        top: 25,
        height: 90,
        tapLeftButton: () {
          context.read<GeneralController>().collectionsController.back();
        },
        tapRightButton: () {
          context
              .read<GeneralController>()
              .collectionsController
              .createCollection();
          context.read<GeneralController>().createRouteOnEdit(currentPage: 1);
        },
        child: Container(
          child: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Text(
                  "Создание",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      fontFamily: fontFamilyMedium,
                      letterSpacing: 2),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(14, 5, 14, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: _header(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
    // if (editHeader) {
    //   FocusScope.of(context).autofocus(focusNode);
    return TextField(
      // focusNode: focusNode,
      autofocus: true,
      maxLines: 1,
      controller: context
          .read<GeneralController>()
          .collectionsController
          .controllerHeader,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintStyle: TextStyle(
          fontSize: 24,
          color: cBackground.withOpacity(0.7),
          fontWeight: FontWeight.w700,
        ),
        hintText: "Название",
      ),
      style: TextStyle(
        color: cBackground,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamily,
      ),
    );
  }

  Widget _image() {
    return StreamBuilder<String>(
        stream:
            context.read<GeneralController>().collectionsController.streamPhoto,
        builder: (context, snapshot) {
          return GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () {
              context
                  .read<GeneralController>()
                  .collectionsController
                  .addImage();
            },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    offset: Offset(0, 4),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  height: (MediaQuery.of(context).size.width - 32) * 240 / 382,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0, 4),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ], color: cBackground.withOpacity(0.9)),
                  child: !snapshot.hasData || snapshot.data == null
                      ? Center(
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                border: Border.all(color: cBlack),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: iconSvg(IconsSvg.camera, color: cBlack),
                              )),
                        )
                      : Image.file(
                          File(snapshot.data),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          );
        });
  }

  Widget _desc() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: cGreen.withOpacity(0.2)),
        ),
      ),
      child: TextField(
        minLines: 5,
        maxLines: 100,
        controller: context
            .read<GeneralController>()
            .collectionsController
            .controllerComment,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 14,
            color: cBlack.withOpacity(0.7),
            fontWeight: FontWeight.w400,
          ),
          hintText: "Описание",
        ),
        style: TextStyle(
            color: cBlack,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: fontFamily),
      ),
    );
  }

  Widget _listAudio() {
    return StreamBuilder<CollectionsState>(
        stream: context
            .read<GeneralController>()
            .collectionsController
            .streamCollections,
        builder: (context, snapshot) {
          List<AudioItem> list = [];
          if (snapshot.hasData && snapshot.data.audios != null &&
              snapshot.data.audios.isNotEmpty)
            list = snapshot.data.audios;
          if (list == null || list.isEmpty) {
            return Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.deferToChild,
                  onTap: () {
                    context
                        .read<GeneralController>()
                        .collectionsController
                        .addAudio();
                    context.read<GeneralController>().createRouteOnEdit(currentPage: 1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1, color: cBlack.withOpacity(0.8)),
                        ),
                      ),
                      child: Text(
                        "Добавить аудиофайл",
                        style: TextStyle(
                          color: cBlack,
                          fontFamily: fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Column(
            children: [
              Column(
                children: List.generate(list.length, (index) {
                  return Column(
                    children: [
                      AudioItemWidget(
                        colorPlay: cSwamp,
                        selected: false,
                        item: list[index],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                }),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.deferToChild,
                    onTap: () {
                      context
                          .read<GeneralController>()
                          .collectionsController
                          .addAudio();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1, color: cBlack.withOpacity(0.8)),
                        ),
                      ),
                      child: Text(
                        "Добавить аудиофайл",
                        style: TextStyle(
                            color: cBlack,
                            fontFamily: fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }
}
