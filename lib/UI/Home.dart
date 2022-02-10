import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/PlayerState.dart';
import 'package:recorder/Rest/Audio/AudioProvider.dart';
import 'package:recorder/UI/Pages/Collections/CollectionsPage.dart';
import 'package:recorder/UI/Pages/Search/SearchPage.dart';
import 'package:recorder/UI/Pages/Restore/Restore.dart';
import 'package:recorder/UI/Pages/Subscription/SubscritionPage.dart';
import 'package:recorder/UI/widgets/MainMenu.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/Pages/AudioList/AudioListPage.dart';
import 'package:recorder/UI/Pages/Profile/ProfilePage.dart';
import 'package:recorder/UI/widgets/Background.dart';
import 'package:recorder/UI/widgets/MainPanel.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:provider/provider.dart';
import 'package:recorder/Utils/app_keys.dart';
import 'package:uni_links/uni_links.dart';
import 'package:recorder/generated/l10n.dart';

import 'Pages/Home/HomePage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color colorActive = cBlue;
  Color colorInactive = cBlack.withOpacity(0.8);

  GeneralController controller;

  Uri _initialUri;
  Uri _latestUri;
  StreamSubscription _sub;

  void _handleLinks() async {
    _sub = getUriLinksStream().listen((Uri uri) {
      if (!mounted) return;
      if (uri != null)
        setState(() {
          _latestUri = uri;
        });
      log("$_latestUri", name: "latestUri");
    }, onError: (err) {
      log("$err", name: "error handle");
    });

    getUriLinksStream().listen((Uri uri) async {
      log("Gotcha link ${uri.path}", name: "Gotcha");
      if (uri != null) {
        var id = uri.path.toString().split("/").last;
        // log("Initial link! $id", name: "initial");
        var decodedId = int.parse(utf8.decode(base64.decode(id)));
        // log("$decodedId", name: "decoded id");
        var audio = await AudioProvider.getFromServer(decodedId);
        controller.playerController.tapButton(audio);
      }
    }, onError: (err) {
      log("$err", name: "Error");
    });

    try {
      _initialUri = await getInitialUri();
      if (_initialUri != null) {
        var id = _initialUri.toString().split("/").last;
        // log("Initial link! $id", name: "initial");
        var decodedId = int.parse(utf8.decode(base64.decode(id)));
        // log("$decodedId", name: "decoded id");
        var audio = await AudioProvider.getFromServer(decodedId);
        controller.playerController.tapButton(audio);
      }
    } catch (err) {
      log("$err", name: "Error!");
    }
  }

  @override
  void initState() {
    super.initState();
    controller = GeneralController();
    _handleLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => controller,
      child: Stack(
        children: [
          Scaffold(
            key: AppKeys.scaffoldKey,
            body: StreamBuilder<AppPlayerState>(
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
                                          : (snapshot.data ?? 0) == 3 ||
                                                  (snapshot.data ?? 0) == 2
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
                            SubscriptionPage(),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
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
                        icon: iconSvg(IconsSvg.home,
                            width: 24, height: 24, color: colorActive),
                        iconInactive: iconSvg(IconsSvg.home,
                            color: colorInactive, width: 24, height: 24),
                        text: Text(
                          S.current.main,
                          style: TextStyle(color: cBlue, fontSize: 10),
                        ),
                      ),
                      ItemMainPanel(
                        icon: iconSvg(IconsSvg.category,
                            width: 24, height: 24, color: colorActive),
                        iconInactive: iconSvg(IconsSvg.category,
                            width: 24, height: 24, color: colorInactive),
                        text: Text(
                          S.current.playlists,
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
                                    child: iconSvg(IconsSvg.voice,
                                        width: 24, height: 24),
                                  ),
                                );
                              }
                              return Container(
                                height: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                        child: iconSvg(IconsSvg.voice,
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
                          S.current.record,
                          style: TextStyle(color: cBlue, fontSize: 10),
                        ),
                      ),
                      ItemMainPanel(
                        icon: iconSvg(IconsSvg.paper,
                            width: 24, height: 24, color: colorActive),
                        iconInactive: iconSvg(IconsSvg.paper,
                            width: 24, height: 24, color: colorInactive),
                        text: Text(
                          S.current.audios,
                          style: TextStyle(color: cBlue, fontSize: 10),
                        ),
                      ),
                      ItemMainPanel(
                        icon: iconSvg(IconsSvg.profile,
                            width: 24, height: 24, color: colorActive),
                        iconInactive: iconSvg(IconsSvg.profile,
                            width: 24, height: 24, color: colorInactive),
                        text: Text(
                          S.current.profile,
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
                          : -MediaQuery.of(context).size.width,
                      child: GestureDetector(
                        onTap: () {
                          controller.setMenu(false);
                        },
                        child: AnimatedContainer(
                            decoration: BoxDecoration(
                              color: snapshot.hasData && snapshot.data
                                  ? cBlack.withOpacity(0.4)
                                  : Colors.transparent,
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
