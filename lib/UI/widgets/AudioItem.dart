import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/PlayerState.dart';
import 'package:recorder/DB/DB.dart';
import 'package:recorder/UI/EditingAudio.dart';
import 'package:recorder/Utils/MemoryDialogs/MemoryDialog.dart';
import 'package:recorder/Utils/MemoryDialogs/DialogRecorder.dart';
import 'package:recorder/Utils/DropMenu/DropMenuItem.dart';
import 'package:recorder/Utils/DropMenu/FocusedMenuHolder.dart';
import 'package:recorder/Utils/time/TimeParse.dart';
import 'package:recorder/models/AudioItem.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:provider/provider.dart';
import 'ButtonPlay.dart';
import 'package:recorder/Rest/Audio/AudioProvider.dart';
import 'package:share/share.dart';
import 'package:recorder/generated/l10n.dart';

class AudioItemWidget extends StatefulWidget {
  final AudioItem item;
  final Color colorPlay;
  final bool selected;
  final bool delete;
  final Function onSelect;
  final bool remove;
  final bool userLogged;

  AudioItemWidget({
    @required this.item,
    this.colorPlay = cBlueSoso,
    this.selected = false,
    this.onSelect,
    this.delete = false,
    this.remove = false,
    this.userLogged = false,
  });

  @override
  _AudioItemWidgetState createState() => _AudioItemWidgetState();
}

class _AudioItemWidgetState extends State<AudioItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => editAudio(widget.item, context.read<GeneralController>()),
      // onLongPress: () => openMenu(), //probably will not work
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: cBackground,
          border: Border.all(color: Color.fromRGBO(58, 58, 85, 0.2)),
          borderRadius: BorderRadius.circular(41),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: 50,
                height: 50,
                child: StreamBuilder<AppPlayerState>(
                    stream: context
                        .read<GeneralController>()
                        .playerController
                        .playerStream,
                    builder: (context, snapshot) {
                      // print("BUTTON STATE item ${snapshot.data.item.id.toString() } current ${widget.item.id} ${snapshot.data}");
                      return ButtonPlay(
                        colorPlay: widget.colorPlay,
                        item: widget.item,
                        onTap: () {
                          context
                              .read<GeneralController>()
                              .playerController
                              .tapButton(widget.item);
                        },
                        play: (!snapshot.hasData ||
                                snapshot.data.state != AudioPlayerState.PLAYING)
                            ? false
                            : snapshot.data.item.id == null
                                ? snapshot.data.item.idS == widget.item.idS
                                : snapshot.data.item.id == widget.item.id,
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 18),
              child: Container(
                width: MediaQuery.of(context).size.width - 172,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.item.name}',
                      style: TextStyle(
                        color: cBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${time(widget.item.duration)}',
                          style: TextStyle(
                            color: cBlack.withOpacity(0.5),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: iconSvg(
                            IconsSvg.cloudStorage,
                            color: widget.item.uploadAudio
                                ? Colors.green
                                : Colors.black12,
                            height: 12,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            tailingButton(
              isDelete: widget.delete,
              isSelect: widget.selected,
              isRemove: widget.remove,
              onSelect: widget.onSelect,
            ),
          ],
        ),
      ),
    );
  }

  Widget tailingButton({
    bool isDelete = false,
    bool isSelect = true,
    bool isRemove = false,
    Function onSelect,
  }) {
    // log("del: $isDelete, sel: $isSelect, rem: $isRemove, fun: $onSelect",
    //     name: "tail");
    if (isDelete) {
      return IconButton(
        onPressed: () {
          if (onSelect != null)
            onSelect();
          else if (widget.item.isLocalAudio)
            context
                .read<GeneralController>()
                .restoreController
                .deleteFinal(widget.item);
          else
            context
                .read<GeneralController>()
                .restoreController
                .deleteFinalCloud(ids: widget.item.idS);
        },
        icon: iconSvg(
          IconsSvg.delete,
          width: 30,
          height: 30,
          color: cBlack,
        ),
      );
    }
    if (isRemove) {
      return IconButton(
        onPressed: () {
          context
              .read<GeneralController>()
              .collectionsController
              .removeAudioFromCollection(widget.item);
        },
        icon: iconSvg(IconsSvg.delete, height: 30, color: cBlack),
      );
    }
    if (isSelect) {
      if (widget.item.select ?? false)
        return GestureDetector(
            onTap: () {
              onSelect();
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: iconSvg(
                IconsSvg.selectedOn,
                height: 50,
                width: 50,
              ),
            ));
      else
        return GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: () {
            onSelect();
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: iconSvg(
              IconsSvg.selectedOff,
              height: 50,
              width: 50,
            ),
          ),
        );
    }
    return openMenu();
  }

  Widget openMenu() {
    return FocusedMenuHolder(
      blurSize: 0,
      blurBackgroundColor: Colors.transparent,
      duration: Duration(milliseconds: 50),
      menuBoxDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      menuWidth: MediaQuery.of(context).size.width / 2,
      menuOffset: 10,
      menuItems: [
        // FocusedMenuItem(
        //   onPressed: () {
        //     addToPlaylist([widget.item], context.read<GeneralController>());
        //   },
        //   title: Text(
        //     "Добавить в подборку",
        //     style: TextStyle(
        //       color: cBlack,
        //       fontWeight: FontWeight.w400,
        //       fontSize: 14,
        //       fontFamily: fontFamily,
        //     ),
        //   ),
        // ),
        FocusedMenuItem(
          onPressed: () {
            editAudio(widget.item, context.read<GeneralController>());
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
        if (widget.userLogged && widget.item.isLocalAudio) //
          FocusedMenuItem(
            onPressed: () {
              context
                  .read<GeneralController>()
                  .recordController
                  .uploadAudio(widget.item);
              context.read<GeneralController>().homeController.load();
            },
            title: Text(
              S.current.upload_to_cloud,
              style: TextStyle(
                color: cBlack,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: fontFamily,
              ),
            ),
          ),
        if (!widget.item.isLocalAudio)
          FocusedMenuItem(
            onPressed: () {
              var audioId = widget.item.idS;
              var encodedId = base64.encode(utf8.encode(audioId.toString()));
              Share.share("${S.current.share_msg}: https://memorybox.ru/audio/$encodedId");
            },
            title: Text(
              S.current.share,
              style: TextStyle(
                  color: cBlack,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontFamily: fontFamily),
            ),
          ),
        // FocusedMenuItem(
        //   onPressed: null,
        //   title: Text(
        //     S.current.download,
        //     style: TextStyle(
        //       color: cBlack,
        //       fontWeight: FontWeight.w400,
        //       fontSize: 14,
        //       fontFamily: fontFamily,
        //     ),
        //   ),
        // ),
        if (widget.item.isLocalAudio)
          FocusedMenuItem(
            onPressed: () async {
              delete(widget.item);
            },
            title: Text(
              S.current.delete_local,
              style: TextStyle(
                color: cBlack,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: fontFamily,
              ),
            ),
          ),
        if (!widget.item.isLocalAudio)
          FocusedMenuItem(
            onPressed: () async {
              delete(widget.item, fromCloud: true);
              // context.read<GeneralController>().homeController.load();
              // context.read<GeneralController>().homeController.loadAudios();
            },
            title: Text(
              S.current.delete_cloud,
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
      child: Container(
        height: 30,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: iconSvg(IconsSvg.moreAudios, width: 18, color: cBlack)),
      ),
    );
  }

  delete(AudioItem item, {bool fromCloud = false}) async {
    print("delete attempt ${item.toMap()}");
    showDialogRecorder(
      context: context,
      title: Text(
        S.current.sure,
        style: TextStyle(
          color: cBlack,
          fontWeight: FontWeight.w400,
          fontSize: 20,
          fontFamily: fontFamily,
        ),
      ),
      body: Text(
        S.current.delete_to_trash,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: cBlack.withOpacity(0.7),
          fontFamily: fontFamily,
          fontSize: 14,
        ),
      ),
      buttons: [
        MemoryDialogButton(
          onPressed: () async {
            if (fromCloud)
              await AudioProvider.deleteOnCloud(ids: item.idS);
            await DBProvider.db.removeAudio(item.id);
            await context.read<GeneralController>().homeController.load();
            Navigator.of(context).pop();
            // closeDialog(AppKeys.scaffoldKey.currentContext);
          },
          textButton: Text(
            S.current.yes,
            style: TextStyle(
                color: cBackground,
                fontSize: 16,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w500),
          ),
          background: cRed,
          borderColor: cRed,
        ),
        MemoryDialogButton(
          onPressed: () {
            // closeDialog(AppKeys.scaffoldKey.currentContext);
            Navigator.of(context).pop();
          },
          textButton: Text(
            S.current.no,
            style: TextStyle(
                color: cBlueSoso,
                fontSize: 16,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w400),
          ),
          borderColor: cBlueSoso,
        ),
      ],
    );
  }
}
