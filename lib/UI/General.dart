import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/PlayerState.dart';
import 'package:recorder/UI/Pages/Collections/CollectionsPage.dart';
import 'package:recorder/UI/Pages/Search/SearchPage.dart';
import 'package:recorder/UI/Pages/Restore/Restore.dart';
import 'package:recorder/UI/widgets/MainMenu.dart';
import 'package:recorder/models/AudioModel.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/Pages/AudioList/AudioListPage.dart';
import 'package:recorder/UI/Pages/Profile/ProfilePage.dart';
import 'package:recorder/UI/Pages/Record/RecordPage.dart';
import 'package:recorder/UI/widgets/Background.dart';
import 'package:recorder/UI/widgets/MainPanel.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:provider/provider.dart';
import 'package:recorder/Utils/app_keys.dart';

import 'Pages/Home/HomePage.dart';

class General extends StatefulWidget {
  @override
  _GeneralState createState() => _GeneralState();
}

class _GeneralState extends State<General> {
  Color colorActive = cBlue;
  Color colorInactive = cBlack.withOpacity(0.8);

  GeneralController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = GeneralController();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => controller,
      child: Stack(
        children: [
          Scaffold(
            key: AppKeys.scaffoldKey,
            body: Stack(
              children: [
                StreamBuilder<PlayerState>(
                    stream: controller.playerController.playerStream,
                    builder: (context, snapshot) {
                      return Container(
                        height: MediaQuery.of(context).size.height -
                            (snapshot.hasData && snapshot.data.playing ? 85 : 0),
                        child: Stack(
                          children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child: StreamBuilder<int>(
                                    stream: controller.streamCurrentPage,
                                    builder: (context, snapshot) {
                                      return Background(
                                          color: (snapshot.data ?? 0) == 1
                                              ? cSwamp
                                              : (snapshot.data ?? 0) == 3 || (snapshot.data ?? 0) == 2
                                              ? cBlue
                                              : null);
                                    })),
                            PageView(
                              // physics: BouncingScrollPhysics(),
                              physics: NeverScrollableScrollPhysics(),
                              controller: controller.pageController,
                              children: [
                                HomePage(),
                                CollectionsPage(),
                                Restore(),
                                AudioListPage(),
                                ProfilePage(),
                                SearchPage(),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: StreamBuilder<int>(
                stream: controller.streamCurrentPage,
                builder: (context, snapshot) {
                  return MainPanel(
                    currentIndex: snapshot.data ?? 0,
                    onChange: (index) async {
                      controller.setPage(index);
                    },
                    items: [
                      ItemMainPanel(
                        icon: IconSvg(IconsSvg.home,
                            width: 24, height: 24, color: colorActive),
                        iconInactive: IconSvg(IconsSvg.home,
                            color: colorInactive, width: 24, height: 24),
                        text: Text(
                          "Главная",
                          style: TextStyle(color: cBlue, fontSize: 10),
                        ),
                      ),
                      ItemMainPanel(
                        icon: IconSvg(IconsSvg.category,
                            width: 24, height: 24, color: colorActive),
                        iconInactive: IconSvg(IconsSvg.category,
                            width: 24, height: 24, color: colorInactive),
                        text: Text(
                          "Подборки",
                          style: TextStyle(color: cBlue, fontSize: 10),
                        ),
                      ),
                      ItemMainPanel(
                        colorActive: cOrange,
                        colorInactive: cOrange,
                        icon: StreamBuilder<RecordState>(
                            stream: controller.recordController.streamRecord,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData ||
                                  (snapshot.hasData &&
                                      snapshot.data.status !=
                                          RecordingStatus.Recording)) {
                                return Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: cOrange,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: IconSvg(IconsSvg.voice,
                                        width: 24, height: 24),
                                  ),
                                );
                              }
                              return Container(
                                height: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 13,
                                      width: 4,
                                      color: cOrange,
                                    ),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: cOrange,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: IconSvg(IconsSvg.voice,
                                            width: 24,
                                            height: 24,
                                            color: cOrange),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        text: Text(
                          "Запись",
                          style: TextStyle(color: cBlue, fontSize: 10),
                        ),
                      ),
                      ItemMainPanel(
                        icon: IconSvg(IconsSvg.paper,
                            width: 24, height: 24, color: colorActive),
                        iconInactive: IconSvg(IconsSvg.paper,
                            width: 24, height: 24, color: colorInactive),
                        text: Text(
                          "Аудиозаписи",
                          style: TextStyle(color: cBlue, fontSize: 10),
                        ),
                      ),
                      ItemMainPanel(
                        icon: IconSvg(IconsSvg.profile,
                            width: 24, height: 24, color: colorActive),
                        iconInactive: IconSvg(IconsSvg.profile,
                            width: 24, height: 24, color: colorInactive),
                        text: Text(
                          "Профиль",
                          style: TextStyle(color: cBlue, fontSize: 10),
                        ),
                      ),
                    ],
                    audioStream: controller.playerController.playerStream,
                  );
                }),
          ),
          StreamBuilder<bool>(
              stream: controller.streamMenu,
              builder: (context, snapshot) {
                return Stack(
                  children: [
                    Positioned(
                      left: snapshot.hasData && snapshot.data
                          ? 0
                          : -MediaQuery.of(context).size.width ,
                      child: GestureDetector(
                        onTap: (){
                          controller.setMenu(false);
                        },
                        child: AnimatedContainer(
                          decoration: BoxDecoration(
                            color: snapshot.hasData&&snapshot.data?cBlack.withOpacity(0.4):Colors.transparent,
                          ),
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            duration: Duration(milliseconds: 200)),
                      ),
                    ),
                    AnimatedPositioned(
                      left: snapshot.hasData && snapshot.data
                          ? 0
                          : -MediaQuery.of(context).size.width * 0.60,
                      child: MainMenu(),
                      duration: Duration(milliseconds: 200),
                    ),
                  ],
                );
              })
        ],
      ),
    );
  }
}
