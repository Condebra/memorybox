import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/HomeController.dart';
import 'package:recorder/models/AudioModel.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/widgets/Appbar.dart';
import 'package:recorder/UI/widgets/AudioItem.dart';
import 'package:recorder/UI/widgets/AudioPreviewGenerate.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:recorder/generated/l10n.dart';
import 'package:provider/provider.dart';
class AudioListPage extends StatefulWidget {

  @override
  _AudioListPageState createState() => _AudioListPageState();
}

class _AudioListPageState extends State<AudioListPage> {

  @override
  void initState() {
    super.initState();
    context.read<GeneralController>().homeController.load();
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
            tapLeftButton: (){
              context.read<GeneralController>().setMenu(true);
            },
            childRight : SizedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 11),
                child: Container(
                  decoration: BoxDecoration(
                  ),
                  width: 27,
                  height: 27,
                ),
              ),
            ),
            top: 25,
            height: 100,
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
          body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: StreamBuilder<HomeState>(
                stream: context.read<GeneralController>().homeController.stream,
                builder: (context, snapshot) {
                  return (!snapshot.hasData || snapshot.data.loading)?Center(child: CircularProgressIndicator(),):Column(
                    children: [
                      SizedBox(
                        height: 43,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 25.0, right: 19.0),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [playlistInfo(snapshot.data), playlistButton(snapshot.data.audios)],
                        ),
                      ),
                      SizedBox(
                        height: 33,
                      ),
                      playlistPreview(snapshot.data.audios),
                      SizedBox(
                        height: 110,
                      ),
                    ],
                  );
                }
              )),
        ),
      ),
    );
  }

  Container playlistButton(List<AudioItem> list) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: cBackground.withOpacity(0.5)),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              // List<AudioItem> list = context.read<GeneralController>().homeController.audios;
              context.read<GeneralController>().playerController.play(list);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: cBackground, borderRadius: BorderRadius.circular(50)),
              child: Row(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: IconSvg(IconsSvg.play,
                          width: 38, color: Color.fromRGBO(140, 132, 226, 1))),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: Text(
                      S.of(context).play_all,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: cBlueSoso,
                          fontFamily: fontFamilyMedium),
                    ),
                  ),
                  SizedBox(width: 10,),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              child: IconSvg(
                IconsSvg.audioRepeat,
                width: 30,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget playlistInfo(HomeState state) {

    String timeInfo(){
      Duration all = Duration(seconds: 0);
      for(int i = 0; i < state.audios.length; i++){
        all = Duration(seconds: all.inSeconds+state.audios[i].duration.inSeconds);
      }
      return "${all.inHours < 10?"0"+all.inHours.toString():all.inHours.toString()}:${all.inMinutes%60 < 10?"0"+(all.inMinutes%60).toString():(all.inMinutes%60).toString()}";

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
              fontFamily: fontFamilyMedium),
        ),
        Text(
          timeInfo(),
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: cBackground,
              fontFamily: fontFamilyMedium),
        )
      ],
    );
  }

  Widget playlistPreview(List<AudioItem> list, {Color colorPlay}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 12),
      child: AudioPreviewGenerate(
          items: list,
          colorPlay: cBlue,
         ),
    );
  }
}
