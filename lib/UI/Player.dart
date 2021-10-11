import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/PlayerState.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/AddToPlaylist.dart';
import 'package:recorder/UI/EditingAudio.dart';
import 'package:recorder/Utils/DropMenu/DropMenuItem.dart';
import 'package:recorder/Utils/DropMenu/FocusedMunu.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:recorder/Utils/app_keys.dart';
import 'package:recorder/Utils/time/TimeParse.dart';
import 'package:provider/provider.dart';

Future<void> showPlayer(GeneralController controller) async {
  await AppKeys.scaffoldKey.currentState.showBottomSheet(
    (context) => PlayerPage(controller: controller),
    backgroundColor: Colors.transparent,
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
      height: MediaQuery.of(context).size.height * 1,
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.96,
            width: MediaQuery.of(context).size.width * 0.98,
            decoration: BoxDecoration(
                color: cBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
            child: StreamBuilder<PlayerState>(
              stream: widget.controller.playerController.playerStream,
              builder: (context, snapshot) {
                if(!snapshot.hasData || snapshot.data.loading){
                  if(!snapshot.hasData){print("data empty");
                   widget.controller.playerController.openBig();}else {
                    print( ' loading ${snapshot.data.loading}');
                  }

                  return Center(child: CircularProgressIndicator(),);
                }else
                return ContentPlayer(
                  snapshot.data
                );
              }
            ),
          )
        ],
      ),
    );
  }

  Widget ContentPlayer(PlayerState state){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        height:  MediaQuery.of(context).size.height * 0.96,
        child: Column(
          children: [
            SizedBox(height: 22,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    behavior: HitTestBehavior.deferToChild,
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: IconSvg(IconsSvg.arrowBottom, )),
                GestureDetector(
                    behavior: HitTestBehavior.deferToChild,
                    onTap: (){

                    },
                    child: FocusedMenuHolder(
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
                            addToPlaylist([state.item], context.read<GeneralController>());
                          }, title: Text("Добавить в подборку",style: TextStyle(color: cBlack, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: fontFamily),),),
                          FocusedMenuItem(onPressed: (){
                            editAudio(state.item, context.read<GeneralController>());
                          }, title: Text("Редактировать",style: TextStyle(color: cBlack, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: fontFamily),),),
                          FocusedMenuItem(onPressed: null, title: Text("Поделиться",style: TextStyle(color: cBlack, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: fontFamily),),),
                          FocusedMenuItem(onPressed: null, title: Text("Скачать",style: TextStyle(color: cBlack, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: fontFamily),),),
                          FocusedMenuItem(onPressed: ()async{
                            await context.read<GeneralController>().restoreController.delete(state.item);
                            context.read<GeneralController>().homeController.load();
                          }, title: Text("Удалить",style: TextStyle(color: cBlack, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: fontFamily),),),
                        ],
                        onPressed: (){},
                        child: IconSvg(IconsSvg.more, color: cBlack, width: 40)))
              ],
            ),
            SizedBox(height: 24,),
            _image(state),
            Spacer(),


            _progress(state),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    behavior: HitTestBehavior.deferToChild,
                    onTap: (){
                      try {
                        if(state.current.inSeconds > 15)
                          widget.controller.playerController.seek(
                              Duration(seconds: state.current.inSeconds - 15));
                        else
                          widget.controller.playerController.seek(
                              Duration(seconds: 0));
                      }catch(e){

                      }
                    },
                    child: IconSvg(IconsSvg.back15)),

                _buttonPlay(state, onTap: (){
                  if(state.state == AudioPlayerState.PLAYING){
                    // todo pause
                    widget.controller.playerController.pause();

                  }else if(state.state == AudioPlayerState.PAUSED){
                    widget.controller.playerController.resume();
                    //todo play
                  }
                }),
                GestureDetector(
                    onTap: (){
                      try {
                        if(state.max.inSeconds - state.current.inSeconds > 15 )
                          widget.controller.playerController.seek(
                              Duration(seconds: state.current.inSeconds + 15));
                        else{
                          widget.controller.playerController.seek(
                              Duration(milliseconds: state.max.inMilliseconds-1));
                        }
                      }catch(e){

                      }
                    },
                    child: IconSvg(IconsSvg.next15)),
              ],
            ),
            SizedBox(height: 126,),
          ],
        ),
      ),
    );
  }
  _image(PlayerState state){
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(25)),
      child: GestureDetector(
        onHorizontalDragEnd: (i){
          if(i.primaryVelocity < 1000){
            widget.controller.playerController.next();
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height*0.96 - 126-80 -40- 150,
          width: (MediaQuery.of(context).size.height*0.96 - 126-80 -40- 150)*344/458,
          child: Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height*0.96 - 126-80 -40 - 150,
                  width: (MediaQuery.of(context).size.height*0.96 - 126-80 -40- 150)*344/458,
                  child: !state.item.isLocalPicture?Image.network(state.item.picture, fit: BoxFit.cover,):state.item.picture == null?Image.asset("assets/images/play.png", fit: BoxFit.cover,):Image.file(File(state.item.picture), fit: BoxFit.cover,),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0),
                        Color.fromRGBO(69, 69, 69, 1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  ),
                  height: MediaQuery.of(context).size.height*0.96 - 126-80 -40- 150,
                  width: (MediaQuery.of(context).size.height*0.96 - 126-80 -40- 150)*344/458,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Container(
                  width: ((MediaQuery.of(context).size.height*0.96 - 126-80 -40- 150)*344/458) - 56,
                  child: Column(

                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(state.item.name, overflow: TextOverflow.ellipsis, style: TextStyle(color: cBackground, fontFamily: fontFamily, fontSize: 24, fontWeight: FontWeight.w400),),
                      SizedBox(height: 18,),
                      Text(state.item.description, overflow: TextOverflow.ellipsis, style: TextStyle(color: cBackground, fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w400),),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonPlay(PlayerState state,{ Function onTap}){
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: (){
        if(onTap != null){
          onTap();
        }
      },
      child: Container(
        width: 80,
        height: 80,
        child: state == null||state.loading == null|| state.loading?Container(
          decoration: BoxDecoration(
            color: cBackground,
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Center(child: CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation<Color>(cBlueSoso)),),
        ):state.state == AudioPlayerState.PLAYING?IconSvg(IconsSvg.pause, color: cOrange, width: 80,height: 80):IconSvg(IconsSvg.play, color: cOrange, width: 50,height: 50),
      ),
    );
  }

  _progress(PlayerState state) {
    return Container(
      width: MediaQuery.of(context).size.width ,
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
                trackHeight: 2.0,
                thumbColor: cBlack,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
                overlayColor: cBlack.withOpacity(0.32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
              ),
              child: Slider(
                min: 0,
                max: (state == null||state.max == null?1.toDouble():state.max.inMilliseconds.toDouble()),
                value: (state == null||state.current == null?0.toDouble():state.current.inMilliseconds.toDouble()).clamp(0, (state == null||state.max == null?1.toDouble():state.max.inMilliseconds.toDouble())),
                onChangeStart: (info){
                  //context.read<GeneralController>().playerController.pause();
                },
                onChanged: (value) {
                  print("CHANGE ${value.toInt()}");
                 widget.controller.playerController.setDuration(Duration(milliseconds: value.toInt()));
                },
                onChangeEnd: (info){
                  print("end");
                  widget.controller.playerController.seek(Duration(milliseconds: info.toInt()));
                },

              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${time(state == null?Duration(seconds: 0):state.current)}", style: TextStyle(color: cBlack, fontSize: 16, fontFamily: fontFamily, fontWeight: FontWeight.w400, ),),
              Text("${time(state == null?Duration(seconds: 0):state.max)}", style: TextStyle(color: cBlack, fontSize: 16, fontFamily: fontFamily, fontWeight: FontWeight.w400, ),),
            ],
          )
        ],
      ),
    );
  }

}
