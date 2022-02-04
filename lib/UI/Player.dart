import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/PlayerState.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/AddToPlaylist.dart';
import 'package:recorder/UI/EditingAudio.dart';
import 'package:recorder/Utils/DropMenu/DropMenuItem.dart';
import 'package:recorder/Utils/DropMenu/FocusedMenuHolder.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:recorder/Utils/app_keys.dart';
import 'package:recorder/Utils/time/TimeParse.dart';
import 'package:provider/provider.dart';
import 'package:recorder/generated/l10n.dart';

Future<void> showPlayer(GeneralController controller) async {
  // await AppKeys.scaffoldKey.currentState.showBottomSheet(
  //   (context) => PlayerPage(controller: controller),
  //   backgroundColor: Colors.transparent,
  // );
  showModalBottomSheet(
    context: AppKeys.scaffoldKey.currentContext,
    builder: (context) => PlayerPage(controller: controller),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}

class PlayerPage extends StatefulWidget {
  final GeneralController controller;

  const PlayerPage({Key key, this.controller}) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.playerController.openBig();
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.playerController.closeBig();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: cBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      child: StreamBuilder<AppPlayerState>(
          stream: widget.controller.playerController.playerStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data.loading) {
              if (!snapshot.hasData) {
                // print("data empty");
                // widget.controller.playerController.openBig();
              } else {
                // print(' loading ${snapshot.data.loading}');
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
              return contentPlayer(snapshot.data);
          }),
      // ),
    );
  }

  Widget contentPlayer(AppPlayerState state) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 6, right: 10, bottom: 24),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              color: cBlack.withOpacity(.3),
              thickness: 3,
              indent: 170,
              endIndent: 170,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: _image(state),
            ),
            nameAndDesc(state),
            Padding(
              padding: EdgeInsets.only(top: 26, bottom: 8),
              child: _progress(state),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.controller.playerController.prev();
                    },
                    child: RotatedBox(
                      quarterTurns: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: iconSvg(IconsSvg.next, color: cBlack),
                      ),
                    ),
                  ),
                  GestureDetector(
                      behavior: HitTestBehavior.deferToChild,
                      onTap: () {
                        try {
                          if (state.current.inSeconds > 15)
                            widget.controller.playerController.seek(Duration(
                                seconds: state.current.inSeconds - 15));
                          else
                            widget.controller.playerController
                                .seek(Duration(seconds: 0));
                        } catch (e) {}
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: iconSvg(IconsSvg.back15),
                      )),
                  _buttonPlay(state, onTap: () {
                    if (state.state == AudioPlayerState.PLAYING) {
                      widget.controller.playerController.pause();
                    } else if (state.state == AudioPlayerState.PAUSED) {
                      widget.controller.playerController.resume();
                    }
                  }),
                  GestureDetector(
                    onTap: () {
                      try {
                        if (state.max.inSeconds - state.current.inSeconds > 15)
                          widget.controller.playerController.seek(
                              Duration(seconds: state.current.inSeconds + 15));
                        else {
                          widget.controller.playerController.seek(Duration(
                              milliseconds: state.max.inMilliseconds - 1));
                        }
                      } catch (e) {}
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: iconSvg(IconsSvg.next15),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.controller.playerController.next();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: iconSvg(IconsSvg.next, color: cBlack),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 26, top: 8, right: 26),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    //there will be repeat button
                    padding: const EdgeInsets.all(4.0),
                    child: iconSvg(IconsSvg.audioRepeat,
                        color: Colors.transparent),
                  ),
                  showMenu(state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _image(AppPlayerState state) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(25)),
      child: GestureDetector(
        onHorizontalDragEnd: (i) {
          if (i.primaryVelocity < 1000) {
            widget.controller.playerController.next();
          }
        },
        child: Container(
          height: 300,
          width: 300,
          child: Stack(
            children: [
              Container(
                height: 300,
                width: 300,
                child: !state.item.isLocalPicture
                    ? Image.network(
                        state.item.picture,
                        fit: BoxFit.cover,
                      )
                    : state.item.picture == null
                        ? Image.asset(
                            "assets/images/play.png",
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(state.item.picture),
                            fit: BoxFit.cover,
                          ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0),
                      Color.fromRGBO(69, 69, 69, .08),
                      Color.fromRGBO(69, 69, 69, .5),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
                  height: 300,
                  width: 300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget nameAndDesc(AppPlayerState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            state.item.name,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: cBlack,
                fontFamily: fontFamily,
                fontSize: 22,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            state.item.description,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: cBlack,
                fontFamily: fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buttonPlay(AppPlayerState state, {Function onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        width: 60,
        height: 60,
        child: state == null || state.loading == null || state.loading
            ? Container(
                decoration: BoxDecoration(
                  color: cBackground,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(cBlueSoso)),
                ),
              )
            : state.state == AudioPlayerState.PLAYING
                ? iconSvg(IconsSvg.pause, color: cOrange, width: 80, height: 80)
                : iconSvg(IconsSvg.play, color: cOrange, width: 50, height: 50),
      ),
    );
  }

  _progress(AppPlayerState state) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 20,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: cBlack,
                inactiveTrackColor: cBlack.withOpacity(.6),
                trackShape: RoundedRectSliderTrackShape(),
                trackHeight: 1.5,
                thumbColor: cBlack,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
                overlayColor: cBlack.withOpacity(0.32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
              ),
              child: Slider(
                min: 0,
                max: (state == null || state.max == null
                    ? 1.toDouble()
                    : state.max.inMilliseconds.toDouble()),
                value: (state == null || state.current == null
                        ? 0.toDouble()
                        : state.current.inMilliseconds.toDouble())
                    .clamp(
                        0,
                        (state == null || state.max == null
                            ? 1.toDouble()
                            : state.max.inMilliseconds.toDouble())),
                onChangeStart: (info) {
                  //context.read<GeneralController>().playerController.pause();
                },
                onChanged: (value) {
                  // print("CHANGE ${value.toInt()}");
                  widget.controller.playerController
                      .setDuration(Duration(milliseconds: value.toInt()));
                },
                onChangeEnd: (info) {
                  // print("end");
                  widget.controller.playerController
                      .seek(Duration(milliseconds: info.toInt()));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${time(state == null ? Duration(seconds: 0) : state.current)}",
                  style: TextStyle(
                    color: cBlack,
                    fontSize: 12,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "${time(state == null ? Duration(seconds: 0) : state.max)}",
                  style: TextStyle(
                    color: cBlack,
                    fontSize: 12,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget showMenu(AppPlayerState state) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {},
      child: FocusedMenuHolder(
        blurSize: 0,
        blurBackgroundColor: Colors.transparent,
        duration: Duration(milliseconds: 50),
        menuBoxDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        menuWidth: MediaQuery.of(context).size.width / 2,
        menuOffset: 10,
        menuItems: [
          FocusedMenuItem(
            onPressed: () {
              addToPlaylist([state.item], context.read<GeneralController>());
            },
            title: Text(
              S.current.add_to_playlist,
              style: TextStyle(
                color: cBlack,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: fontFamily,
              ),
            ),
          ),
          FocusedMenuItem(
            onPressed: () {
              editAudio(state.item, context.read<GeneralController>());
            },
            title: Text(
              S.current.edit,
              style: TextStyle(
                color: cBlack,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: fontFamily,
              ),
            ),
          ),
          FocusedMenuItem(
            onPressed: null,
            title: Text(
              S.current.share,
              style: TextStyle(
                color: cBlack,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: fontFamily,
              ),
            ),
          ),
          // FocusedMenuItem(
          //   onPressed: null,
          //   title: Text(
          //     S.current.download,
          //     style: TextStyle(
          //         color: cBlack,
          //         fontWeight: FontWeight.w400,
          //         fontSize: 14,
          //         fontFamily: fontFamily),
          //   ),
          // ),
          FocusedMenuItem(
            onPressed: () async {
              await context
                  .read<GeneralController>()
                  .restoreController
                  .delete(state.item);
              context.read<GeneralController>().homeController.load();
            },
            title: Text(
              S.current.delete,
              style: TextStyle(
                color: cBlack,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: fontFamily,
              ),
            ),
          ),
        ],
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: iconSvg(IconsSvg.more, color: cBlack, width: 30),
        ),
      ),
    );
  }
}
