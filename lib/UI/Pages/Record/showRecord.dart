import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/PlayerState.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/Utils/DialogsIntegron/DialogIntegron.dart';
import 'package:recorder/Utils/DialogsIntegron/DialogLoading.dart';
import 'package:recorder/Utils/DialogsIntegron/DialogRecorder.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:recorder/Utils/app_keys.dart';
import 'package:recorder/models/Put.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showRecord(GeneralController controller) async {
  await AppKeys.scaffoldKey.currentState.showBottomSheet(
    (context) => RecordPage(controller),
    backgroundColor: Colors.transparent,
  );
}

class RecordPage extends StatefulWidget {
  final GeneralController controller;

  RecordPage(this.controller);

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.recordController.closeSheet();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.80,
            width: MediaQuery.of(context).size.width * 0.98,
            decoration: BoxDecoration(
                color: cBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
            child: StreamBuilder<RecordState>(
                stream: widget.controller.recordController.streamRecord,
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data.status == RecordingStatus.Initialized) {
                    return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(cBlueSoso)),
                    );
                  } else if (snapshot.data.status ==
                      RecordingStatus.Recording) {
                    return _contentRecording(snapshot.data);
                  } else {
                    return _contentListening(snapshot.data.playerState);
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget _contentRecording(RecordState state) {
    return Column(
      children: [
        SizedBox(
          height: 32,
        ),

        /// Панель
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: () {
                widget.controller.recordController.closeSheet();
                Navigator.pop(context);
              },
              child: Text(
                "Отменить",
                style: TextStyle(
                    color: cBlack,
                    fontSize: 16,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        Spacer(),

        /// Заголовок
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Запись",
              style: TextStyle(
                  color: cBlack,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily,
                  fontSize: 24),
            )
          ],
        ),
        Spacer(),

        /// Полоса мощности
        Container(
          height: 70,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  color: cBlack,
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: List.generate(state.power.length, (index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 1,
                        ),
                        Container(
                          height: state.power[index].toDouble().abs() *
                              70 /
                              state.maxPower.abs(),
                          width: 2,
                          decoration: BoxDecoration(
                              color: cBlack,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        )
                      ],
                    );
                  }),
                ),
              )
            ],
          ),
        ),
        Spacer(),

        /// Продолжительность записи
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  color: cRed),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              time(state.duration),
              style: TextStyle(
                  color: cBlack,
                  fontSize: 18,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.deferToChild,
                  onTap: () async {
                    widget.controller.recordController
                        .tapPause(widget.controller.collectionsController);
                    // ==========================================================================stop!
                    // Put res = await widget.controller.recordController.save();
                    // await widget.controller.homeController.load();
                  },
                  child: Container(
                    height: 80,
                    width: 80,
                    child: IconSvg(IconsSvg.pause, color: cOrange),
                  ),
                ),
                Container(
                  height: 28,
                  width: 4,
                  color: cOrange,
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: 100,
        ),
      ],
    );
  }

  Widget _contentListening(PlayerState state) {
    return Column(
      children: [
        SizedBox(
          height: 32,
        ),

        /// Панель
        Container(
          width: MediaQuery.of(context).size.width * 0.98,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 30,
              ),
              InkWell(
                  onTap: () async {
                    Put res = await widget.controller.recordController.upload();
                  },
                  child: IconSvg(
                    IconsSvg.cloudStorage,
                    width: 25,
                    height: 25,
                  )),
              // Spacer(),
              SizedBox(
                width: 20,
              ),
              // IconSvg(IconsSvg.download, width: 30, height: 30),
              // Spacer(),
              InkWell(
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  enableFeedback: false,
                  onTap: () {
                    showDialogRecorder(
                        context: context,
                        title: Text(
                          "Точно удалить?",
                          style: TextStyle(
                            color: cBlack,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            fontFamily: fontFamily,
                          ),
                        ),
                        body: Text(
                          "Запись будет безвозвратно удалена ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cBlack.withOpacity(0.7),
                            fontFamily: fontFamily,
                            fontSize: 14,
                          ),
                        ),
                        buttons: [
                          DialogIntegronButton(
                              onPressed: () {
                                closeDialog(context);
                                closeDialog(context);
                              },
                              textButton: Text(
                                "Удалить",
                                style: TextStyle(
                                  color: cBackground,
                                  fontSize: 16,
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              background: cRed,
                              borderColor: cRed),
                          DialogIntegronButton(
                            onPressed: () {
                              closeDialog(context);
                            },
                            textButton: Text(
                              "Нет",
                              style: TextStyle(
                                color: cBlueSoso,
                                fontSize: 16,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            borderColor: cBlueSoso,
                          ),
                        ]);
                  },
                  child: IconSvg(
                    IconsSvg.delete,
                    width: 25,
                    height: 25,
                  )),
              Spacer(),
              Container(
                height: 30,
                width: 30,
                child: StreamBuilder<RecordState>(
                    stream: widget.controller.recordController.streamRecord,
                    builder: (context, snapshot) {
                      return snapshot.hasData && snapshot.data.loading
                          ? CircularProgressIndicator()
                          : SizedBox();
                    }),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () async {
                  // Navigator.pop(AppKeys.scaffoldKey.currentState.context);
                  Put res = await widget.controller.recordController.save();
                  await widget.controller.homeController.load();
                },
                child: Text(
                  "Сохранить?",
                  style: TextStyle(
                    color: cBlack,
                    fontSize: 16,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
            ],
          ),
        ),
        Spacer(),
        Spacer(),
        Column(
          children: [
            TextField(
              textAlign: TextAlign.center,
              controller: widget.controller.recordController.nameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                    color: cBlack,
                    fontWeight: FontWeight.w400,
                    fontFamily: fontFamily,
                    fontSize: 24),
                hintText: "Название",
              ),
              style: TextStyle(
                  color: cBlack,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily,
                  fontSize: 24),
            ),
            SizedBox(
              height: 10,
            ),
            //Text("описание", style: TextStyle(color: cBlack.withOpacity(0.5), fontWeight: FontWeight.w400, fontFamily: fontFamily, fontSize: 16),),
            TextField(
              textAlign: TextAlign.center,
              controller: widget.controller.recordController.descController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                    color: cBlack.withOpacity(0.5),
                    fontWeight: FontWeight.w400,
                    fontFamily: fontFamily,
                    fontSize: 16),
                hintText: "описание",
              ),
              style: TextStyle(
                  color: cBlack.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily,
                  fontSize: 16),
            ),
          ],
        ),
        Spacer(),
        _slider(state),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
                behavior: HitTestBehavior.deferToChild,
                onTap: () {
                  try {
                    if (state.current.inSeconds > 15)
                      widget.controller.recordController.seek(
                          Duration(seconds: state.current.inSeconds - 15));
                    else {
                      widget.controller.recordController
                          .seek(Duration(seconds: 0));
                    }
                  } catch (e) {}
                },
                child: IconSvg(IconsSvg.back15)),
            GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: () {
                widget.controller.recordController.tapButtonPlayer();
              },
              child: Container(
                height: 80,
                width: 80,
                child: IconSvg(
                    state.state == AudioPlayerState.PLAYING
                        ? IconsSvg.pause
                        : IconsSvg.play,
                    color: cOrange),
              ),
            ),
            GestureDetector(
                onTap: () {
                  try {
                    if (state.max.inSeconds - state.current.inSeconds > 15)
                      widget.controller.recordController.seek(
                          Duration(seconds: state.current.inSeconds + 15));
                    else {
                      widget.controller.recordController.seek(
                          Duration(milliseconds: state.max.inMilliseconds));
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: IconSvg(IconsSvg.next15)),
          ],
        ),
        SizedBox(
          height: 128,
        ),
      ],
    );
  }

  Widget _slider(PlayerState state) {
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
                inactiveTrackColor: cBlack,
                trackShape: RoundedRectSliderTrackShape(),
                trackHeight: 2.5,
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
                value: (state == null ||
                        state.current == null ||
                        state.state == AudioPlayerState.STOPPED
                    ? 0.toDouble()
                    : state.current.inMilliseconds.toDouble()),
                onChangeStart: (info) {
                  //context.read<GeneralController>().playerController.pause();
                },
                onChanged: (value) {
                  print("CHANGE ${value.toInt()}");
                  widget.controller.recordController
                      .setDuration(Duration(milliseconds: value.toInt()));
                },
                onChangeEnd: (info) {
                  print("end");
                  widget.controller.recordController
                      .seek(Duration(milliseconds: info.toInt()));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${time(state == null || state.state == AudioPlayerState.STOPPED ? Duration(seconds: 0) : state.current)}",
                  style: TextStyle(
                    color: cBlack,
                    fontSize: 16,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "${time(state == null ? Duration(seconds: 0) : state.max)}",
                  style: TextStyle(
                    color: cBlack,
                    fontSize: 16,
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

  String time(Duration duration) {
    String nullCheck(int c) {
      if (c < 10) {
        return "0${c}";
      } else {
        return c.toString();
      }
    }

    String t = "";
    if (duration == null) {
      return t;
    } else {
      if (duration.inHours > 0) {
        t +=
            "${duration.inHours}:${nullCheck(duration.inMinutes % 60)}:${nullCheck(duration.inSeconds % 60)}";
      } else if (duration.inMinutes > 0) {
        t += "${duration.inMinutes % 60}:${nullCheck(duration.inSeconds % 60)}";
      } else {
        t += "00:${nullCheck(duration.inSeconds % 60)}";
      }
    }
    return t;
  }
}
