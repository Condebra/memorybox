import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/PlayerState.dart';
import 'package:recorder/UI/AddToPlaylist.dart';
import 'package:recorder/UI/EditingAudio.dart';
import 'package:recorder/Utils/DropMenu/DropMenuItem.dart';
import 'package:recorder/Utils/DropMenu/FocusedMunu.dart';
import 'package:recorder/Utils/time/TimeParse.dart';
import 'package:recorder/models/AudioModel.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:provider/provider.dart';
import 'ButtonPlay.dart';

class AudioItemWidget extends StatefulWidget {
  final AudioItem item;
  final Color colorPlay;
  final bool selected;
  final bool delete;
  final Function onSelect;

  AudioItemWidget({
    @required this.item,
    this.colorPlay = cBlueSoso,
    this.selected = false,
    this.onSelect,
    this.delete = false
  });

  @override
  _AudioItemWidgetState createState() => _AudioItemWidgetState();
}

class _AudioItemWidgetState extends State<AudioItemWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: cBackground,
          border: Border.all(color: Color.fromRGBO(58, 58, 85, 0.2)),
          borderRadius: BorderRadius.circular(41)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: 50,
              height: 50,
              child: StreamBuilder<PlayerState>(
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
                      play: !snapshot.hasData ? false : !(snapshot.data.state == AudioPlayerState.PLAYING) ? false : snapshot.data.item.id == null?snapshot.data.item.idS == widget.item.idS:snapshot.data.item.id == widget.item.id,
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
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    '${time(widget.item.duration)}',
                    style: TextStyle(
                        color: cBlack.withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          ),
          //todo
          widget.delete? InkWell(
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              enableFeedback: false,
              onTap: widget.onSelect != null?widget.onSelect():(){
                context.read<GeneralController>().restoreController.delete(widget.item);
              },
              child: Container(height: 30, width: 30, child: IconSvg(IconsSvg.delete, width: 30, height: 30, color: cBlack),)):!widget.selected
              ? FocusedMenuHolder(
            blurSize: 0,
            blurBackgroundColor: Colors.transparent,
            duration: Duration(milliseconds: 50),
            menuBoxDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            menuWidth: MediaQuery.of(context).size.width/2,
            menuOffset: 10,
            menuItems:[

              FocusedMenuItem(onPressed: (){
                addToPlaylist([widget.item], context.read<GeneralController>());
              }, title: Text("Добавить в подборку",style: TextStyle(color: cBlack, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: fontFamily),),),
              FocusedMenuItem(onPressed: (){
                editAudio(widget.item, context.read<GeneralController>());
              }, title: Text("Редактировать",style: TextStyle(color: cBlack, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: fontFamily),),),
              FocusedMenuItem(onPressed: null, title: Text("Поделиться",style: TextStyle(color: cBlack, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: fontFamily),),),
              FocusedMenuItem(onPressed: null, title: Text("Скачать",style: TextStyle(color: cBlack, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: fontFamily),),),
              FocusedMenuItem(onPressed: ()async{
                await context.read<GeneralController>().restoreController.delete(widget.item);
                context.read<GeneralController>().homeController.load();
              }, title: Text("Удалить",style: TextStyle(color: cBlack, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: fontFamily),),),
            ],
            onPressed: (){},
                child: Container(
                  height: 30,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: IconSvg(IconsSvg.moreAudios, width: 18, color: cBlack)),
                ),
              )
              : widget.item.select ?? false
                  ? GestureDetector(
                      behavior: HitTestBehavior.deferToChild,
                      onTap: () {
                        widget.onSelect == null ? null : widget.onSelect();
                      },
                      child:
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: IconSvg(IconsSvg.selectedOn, height: 50, width: 50),
                          ))
                  : GestureDetector(
                      behavior: HitTestBehavior.deferToChild,
                      onTap: () {
                        widget.onSelect == null ? null : widget.onSelect();
                      },
                      child:
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: IconSvg(IconsSvg.selectedOff, height: 50, width: 50),
                          )),
        ],
      ),
    );
  }
}
