import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/CollectionsState.dart';
import 'package:recorder/Controllers/States/PlayerState.dart';
import 'package:recorder/Controllers/States/RestoreState.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:provider/provider.dart';
import 'package:recorder/generated/l10n.dart';

class ItemMainPanel {
  final Widget icon;
  final Widget iconInactive;
  final Text text;
  final Function onTap;
  final Color colorActive;
  final Color colorInactive;

  ItemMainPanel(
      {this.colorActive = cBlue,
      this.colorInactive = cBlack,
      @required this.icon,
      this.iconInactive,
      @required this.text,
      this.onTap})
      : assert(icon != null);
}

class MainPanel extends StatefulWidget {
  final Color backgroundColor;
  final int currentIndex;
  final double height;
  final List<ItemMainPanel> items;
  Function(int index) onChange;
  Stream audioStream;

  MainPanel({
    Key key,
    this.backgroundColor = cBackground,
    this.currentIndex = 0,
    this.height,
    @required this.items,
    @required this.audioStream,
    this.onChange,
  })  : assert(items.isNotEmpty),
        super(key: key);

  @override
  _MainPanelState createState() => _MainPanelState();
}

class _MainPanelState extends State<MainPanel> {
  double offset;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: StreamBuilder<AppPlayerState>(
        stream: widget.audioStream,
        builder: (context, snapshot) {
          double editHeight = 0;
          if (snapshot.hasData) {
            if (snapshot.data.playing && !snapshot.data.playerBig) {
              editHeight = 75;
            }
          }
          return AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: MediaQuery.of(context).size.width,
            height: (widget.height ?? 100) + editHeight,
            child: Stack(
              children: [
                AnimatedPadding(
                  duration: Duration(milliseconds: 400),
                  padding: EdgeInsets.only(
                      bottom: (snapshot.hasData && snapshot.data.playing)
                          ? (widget.height ?? 100)
                          : 0),
                  child: player(snapshot.data),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 50,
                          spreadRadius: 10,
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                        )
                      ],
                      color: widget.backgroundColor,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: (widget.height ?? 100),
                    child: StreamBuilder<RestoreState>(
                      stream: context
                          .read<GeneralController>()
                          .restoreController
                          .streamRestore,
                      builder: (context, snapshot) {
                        return StreamBuilder<int>(
                          stream: context
                              .read<GeneralController>()
                              .streamCurrentPage,
                          builder: (context, snapshotPage) {
                            return StreamBuilder<CollectionsState>(
                              stream: context
                                  .read<GeneralController>()
                                  .collectionsController
                                  .streamCollections,
                              builder: (context, snapshotCollections) {
                                return Stack(
                                  children: [
                                    AnimatedPositioned(
                                      left: (snapshotCollections.hasData &&
                                              snapshotCollections.data.stateSelect ==
                                                  CollectionStates.select)
                                          ? 0.0
                                          : (!snapshot.hasData) ||
                                                  !(snapshot.data.select ??
                                                      false) ||
                                                  snapshotPage.data != 2
                                              ? -MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  2
                                              : -MediaQuery.of(context)
                                                  .size
                                                  .width,
                                      duration: Duration(milliseconds: 200),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: (widget.height ?? 100),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    context
                                                        .read<
                                                            GeneralController>()
                                                        .collectionsController
                                                        .addToPlaylistSelect(
                                                            context.read<
                                                                GeneralController>());
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        child: iconSvg(
                                                          IconsSvg.addOutline,
                                                          width: 30,
                                                          height: 30,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        S.current.add,
                                                        style: TextStyle(
                                                          color: cBlack,
                                                          fontFamily:
                                                              fontFamily,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    //todo
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        child: iconSvg(
                                                          IconsSvg.upload,
                                                          width: 30,
                                                          height: 30,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        S.current.share,
                                                        style: TextStyle(
                                                          color: cBlack,
                                                          fontFamily:
                                                              fontFamily,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    //todo
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        child: iconSvg(
                                                          IconsSvg.download,
                                                          width: 30,
                                                          height: 30,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        S.current.download,
                                                        style: TextStyle(
                                                          color: cBlack,
                                                          fontFamily:
                                                              fontFamily,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    context
                                                        .read<
                                                            GeneralController>()
                                                        .collectionsController
                                                        .deleteSelectAudio(context
                                                            .read<
                                                                GeneralController>()
                                                            .restoreController);
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        child: iconSvg(
                                                          IconsSvg.delete,
                                                          width: 30,
                                                          height: 30,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        S.current.delete,
                                                        style: TextStyle(
                                                          color: cBlack,
                                                          fontFamily:
                                                              fontFamily,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: (widget.height ?? 100),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    context
                                                        .read<
                                                            GeneralController>()
                                                        .restoreController
                                                        .restoreSelect();
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        child: iconSvg(
                                                          IconsSvg.swap,
                                                          width: 30,
                                                          height: 30,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        S.current.restore,
                                                        style: TextStyle(
                                                          color: cBlack,
                                                          fontFamily:
                                                              fontFamily,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    context
                                                        .read<
                                                            GeneralController>()
                                                        .restoreController
                                                        .deleteSelect();
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        child: iconSvg(
                                                          IconsSvg.delete,
                                                          width: 30,
                                                          height: 30,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        S.current.delete,
                                                        style: TextStyle(
                                                          color: cBlack,
                                                          fontFamily:
                                                              fontFamily,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: (widget.height ?? 100),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: List.generate(
                                                widget.items.length,
                                                (index) {
                                                  Text text =
                                                      widget.items[index].text;
                                                  if (widget
                                                          .items[index].text !=
                                                      null)
                                                    text.style
                                                        .copyWith(fontSize: 16);

                                                  return Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            widget.items.length,
                                                    child: InkWell(
                                                      onTap: () {
                                                        widget.items[index]
                                                                    .onTap !=
                                                                null
                                                            ? widget
                                                                .items[index]
                                                                .onTap()
                                                            : null;
                                                        widget.onChange != null
                                                            ? widget
                                                                .onChange(index)
                                                            : null;
                                                      },
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          index ==
                                                                  widget
                                                                      .currentIndex
                                                              ? widget
                                                                  .items[index]
                                                                  .icon
                                                              : widget
                                                                      .items[
                                                                          index]
                                                                      .iconInactive ??
                                                                  widget
                                                                      .items[
                                                                          index]
                                                                      .icon,
                                                          SizedBox(
                                                            height: 12,
                                                          ),
                                                          text == null
                                                              ? SizedBox()
                                                              : Text(
                                                                  text.data,
                                                                  style: text
                                                                      .style
                                                                      .copyWith(
                                                                    color: index ==
                                                                            widget
                                                                                .currentIndex
                                                                        ? widget
                                                                            .items[
                                                                                index]
                                                                            .colorActive
                                                                        : widget
                                                                            .items[index]
                                                                            .colorInactive,
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    AnimatedPositioned(
                                      left: (!snapshot.hasData) ||
                                              !(snapshot.data.select ??
                                                  false) ||
                                              snapshotPage.data != 2
                                          ? 0.0
                                          : MediaQuery.of(context).size.width,
                                      duration: Duration(milliseconds: 200),
                                      child: SizedBox(),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget player(AppPlayerState state) {
    String time(Duration duration) {
      String nullCheck(int c) {
        if (c < 10) {
          return "0$c";
        }
        return c.toString();
      }

      String t = "";
      if (duration == null) {
        return t;
      } else {
        if (duration.inHours > 0) {
          t +=
              "${duration.inHours}:${nullCheck(duration.inMinutes % 60)}:${nullCheck(duration.inSeconds % 60)}";
        } else if (duration.inMinutes > 0) {
          t +=
              "${duration.inMinutes % 60}:${nullCheck(duration.inSeconds % 60)}";
        } else {
          t += "00:${nullCheck(duration.inSeconds % 60)}";
        }
      }
      return t;
    }

    return GestureDetector(
      onTap: () {
        context.read<GeneralController>().openPlayer();
      },
      onVerticalDragStart: (inf) {
        offset = inf.globalPosition.dy;
      },
      onVerticalDragEnd: (inf) {
        print("${inf.primaryVelocity}");
        if (inf.primaryVelocity > 800) {
          context.read<GeneralController>().playerController.stop();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(140, 132, 226, 1),
              Color.fromRGBO(108, 104, 159, 1)
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                child: buttonPlay(state, onTap: () {
                  if (state.state == AudioPlayerState.PLAYING) {
                    context.read<GeneralController>().playerController.pause();
                  } else if (state.state == AudioPlayerState.PAUSED) {
                    context.read<GeneralController>().playerController.resume();
                  }
                }),
              ),
              Container(
                width: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      state == null || state.item == null
                          ? ""
                          : state.item.name,
                      style: TextStyle(
                          color: cBackground,
                          fontWeight: FontWeight.w400,
                          fontFamily: fontFamily,
                          fontSize: 14),
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                          child: Text(
                            "${time(state == null ? Duration(seconds: 0) : state.current)}",
                            style: TextStyle(
                              color: cBackground.withOpacity(0.7),
                              fontSize: 10,
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Container(
                          height: 13,
                          width: 190,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: cBackground,
                              inactiveTrackColor: cBackground,
                              trackShape: RoundedRectSliderTrackShape(),
                              trackHeight: 1.5,
                              thumbColor: cBackground,
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 6.0),
                              overlayColor: cBackground.withOpacity(0.32),
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 10.0),
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
                                          : state.max.inMilliseconds
                                              .toDouble())),
                              onChangeStart: (info) {
                                //context.read<GeneralController>().playerController.pause();
                              },
                              onChanged: (value) {
                                print("CHANGE ${value.toInt()}");
                                context
                                    .read<GeneralController>()
                                    .playerController
                                    .setDuration(
                                        Duration(milliseconds: value.toInt()));
                              },
                              onChangeEnd: (info) {
                                print("end");
                                context
                                    .read<GeneralController>()
                                    .playerController
                                    .seek(Duration(milliseconds: info.toInt()));
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                          child: Text(
                            "${time(state == null ? Duration(seconds: 0) : state.max)}",
                            style: TextStyle(
                              color: cBackground.withOpacity(0.7),
                              fontSize: 10,
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<GeneralController>().playerController.next();
                },
                icon: iconSvg(IconsSvg.next),
              ),
              // Container(
              //   width: 82,
              //   child: InkWell(
              //     onTap: () {
              //       context.read<GeneralController>().playerController.next();
              //     },
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         IconSvg(IconsSvg.next),
              //         SizedBox(
              //           width: 20,
              //         ),
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonPlay(AppPlayerState state, {Function onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        width: 50,
        height: 50,
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
                ? iconSvg(IconsSvg.pause,
                    color: cBackground, width: 50, height: 50)
                : iconSvg(IconsSvg.play,
                    color: cBackground, width: 50, height: 50),
      ),
    );
  }
}
