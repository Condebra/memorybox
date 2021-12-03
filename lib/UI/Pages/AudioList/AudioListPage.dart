import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/HomeController.dart';
import 'package:recorder/models/AudioItem.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/widgets/Appbar.dart';
import 'package:recorder/UI/widgets/AudioPreviewGenerate.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:recorder/generated/l10n.dart';
import 'package:provider/provider.dart';

class AudioListPage extends StatefulWidget {
  @override
  _AudioListPageState createState() => _AudioListPageState();
}

class _AudioListPageState extends State<AudioListPage> {
  var repeatColorActive = Color.fromRGBO(255, 255, 255, 1);
  var repeatColorInActive = Color.fromRGBO(0, 0, 0, 1.0);
  bool repeatActive = false;

  @override
  void initState() {
    super.initState();
    context.read<GeneralController>().homeController.loadAudios();
    context.read<GeneralController>().homeController.loadServerAudios();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.sync(context.read<GeneralController>().onWillPop),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: cBackground.withOpacity(0.0),
          appBar: MyAppBar(
            buttonMore: true,
            buttonBack: false,
            buttonMenu: true,
            padding: 10,
            top: 25,
            height: 100,
            tapLeftButton: () {
              context.read<GeneralController>().setMenu(true);
            },
            childRight: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: IconButton(
                onPressed: () {
                  context.read<GeneralController>().setPage(2, restore: true);
                },
                icon: IconSvg(IconsSvg.delete, color: cBackground),
              ),
            ),
            child: Container(
              child: Column(
                children: [
                  Text(
                    S.of(context).audio_appbar,
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        fontFamily: fontFamilyMedium,
                        letterSpacing: 2),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    S.of(context).audio_appbar_subtitle,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: fontFamilyMedium,
                        letterSpacing: 2),
                  )
                ],
              ),
            ),
          ),
          body: StreamBuilder<HomeState>(
              stream: context.read<GeneralController>().homeController.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(
                      color: cBlack,
                    ),
                  );
                if (snapshot.data.audios.isEmpty)
                  return Center(
                    child: Text(
                      'Тут пусто',
                      style: TextStyle(
                          color: cBlack.withOpacity(0.7),
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          fontFamily: fontFamily),
                    ),
                  );
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: 44, bottom: 110),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 25.0, right: 19.0),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            playlistInfo(snapshot.data),
                            playlistButton(snapshot.data.audios)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 33,
                      ),
                      playlistPreview(snapshot.data.audios),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  Container playlistButton(List<AudioItem> list) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: cBackground.withOpacity(0.1)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // List<AudioItem> list = context.read<GeneralController>().homeController.audios;
              context
                  .read<GeneralController>()
                  .playerController
                  .play(list, repeat: repeatActive);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: cBackground, borderRadius: BorderRadius.circular(50)),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: IconSvg(
                      IconsSvg.play,
                      width: 38,
                      color: Color.fromRGBO(140, 132, 226, 1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: Text(
                      S.of(context).play_all,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: cBlueSoso,
                        fontFamily: fontFamilyMedium,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                repeatActive = !repeatActive;
                setState(() {});
              },
              child: IconSvg(
                IconsSvg.audioRepeat,
                color: repeatActive ? repeatColorActive : repeatColorInActive,
                width: 30,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget playlistInfo(HomeState state) {
    String timeInfo() {
      Duration all = Duration(seconds: 0);
      for (int i = 0; i < state.audios.length; i++) {
        all = Duration(
            seconds: all.inSeconds + state.audios[i].duration.inSeconds);
      }
      return "${all.toString().split(".").first.padLeft(8, "0")}";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${state.audios.length} ${S.of(context).audio}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: cBackground,
            fontFamily: fontFamilyMedium,
          ),
        ),
        Text(
          timeInfo(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: cBackground,
            fontFamily: fontFamilyMedium,
          ),
        )
      ],
    );
  }

  Widget playlistPreview(List<AudioItem> list, {Color colorPlay}) {
    // context.read<GeneralController>().homeController.loadAudios();
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 12),
      child: AudioPreviewGenerate(
        items: list,
        colorPlay: cBlue,
      ),
    );
  }
}
