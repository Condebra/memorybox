import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/CollectionsState.dart';
import 'package:recorder/Style.dart';
import 'package:provider/provider.dart';
import 'package:recorder/UI/widgets/Appbar.dart';
import 'package:recorder/UI/widgets/AudioItem.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:recorder/models/AudioModel.dart';

class StateSelectSeveralCollection extends StatefulWidget {
  @override
  _StateSelectSeveralCollectionState createState() => _StateSelectSeveralCollectionState();
}

class _StateSelectSeveralCollectionState extends State<StateSelectSeveralCollection> {

  bool openDesc = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBlack.withOpacity(0.0),
      appBar: MyAppBar(
        buttonMore: false,
        buttonMenu: false,
        buttonBack: true,
        buttonAdd: false,
        buttonDone: true,
        padding: 18,
        top: 16,
        textRightButton: "отменить",
        height: 90,
        tapLeftButton: (){
          context.read<GeneralController>().collectionsController.back();
        },
        tapRightButton:  (){
          //todo save
          context.read<GeneralController>().collectionsController.back();
        },
        child: Container(
          child: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Text(
                  "Выбрать",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      fontFamily: fontFamilyMedium,
                      letterSpacing: 2),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _content(),
    );
  }


  Widget _content(){
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 24,),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width:MediaQuery.of(context).size.width - 40,
                    child: _header()),
              ],
            ),
          ),
          SizedBox(height: 20,),
          _image(),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 28,right: 30),
            child: _desc(),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 17),
            child: _listAudio(),
          ),
          SizedBox(height: 100,),



        ],
      ),

    );
  }


  Widget _listAudio(){
    return StreamBuilder<CollectionsState>(
        stream: context.read<GeneralController>().collectionsController.streamCollections,
        builder: (context, snapshot) {
          List<AudioItem> list = [];
          if(snapshot.hasData){
            if(snapshot.data.audiosSearch != null && snapshot.data.audiosSearch.isNotEmpty){
              list = snapshot.data.audiosSearch;
            }else{
              list = snapshot.data.audiosAll;
            }
          }
          if(list == null || list.isEmpty){return SizedBox();}else
            return Column(
              children: List.generate(list.length, (index) {
                return Column(
                  children: [
                    AudioItemWidget(
                      colorPlay: cSwamp,
                      selected: true,
                      onSelect: (){
                        context.read<GeneralController>().collectionsController.selectAudio(list[index]);
                      },
                      item: list[index],
                    ),
                    SizedBox(height: 10,),
                  ],
                );
              }),
            );
        }
    );

  }

  Widget _header(){
    return StreamBuilder<CollectionsState>(
        stream: context.read<GeneralController>().collectionsController.streamCollections,
        builder: (context, snapshot) {
          return Text(snapshot.data.currentItem.name??"Подборка", style: TextStyle(color: cBackground, fontSize: 24, fontWeight: FontWeight.w700, fontFamily: fontFamily),);
        }
    );
  }
  Widget _image(){

    String timeInfo(Duration duration){
      Duration all =duration;

      return "${all.inHours < 10?"0"+all.inHours.toString():all.inHours.toString()}:${all.inMinutes%60 < 10?"0"+(all.inMinutes%60).toString():(all.inMinutes%60).toString()}";

    }

    return StreamBuilder<CollectionsState>(
        stream: context.read<GeneralController>().collectionsController.streamCollections,
        builder: (context, snapshot) {
          return GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: (){

            },
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: Container(
                  width: MediaQuery.of(context).size.width-32,
                  height: (MediaQuery.of(context).size.width-32)*240/382,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            offset: Offset(0,4),
                            blurRadius: 20,
                            spreadRadius: 0
                        )
                      ],
                      color: cBackground.withOpacity(0.9)
                  ),
                  child: Stack(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width-32,
                          height: (MediaQuery.of(context).size.width-32)*240/382,
                          child:  snapshot.data.currentItem.picture == null?Image.asset('assets/images/play.png', fit: BoxFit.cover,):snapshot.data.currentItem.isLocalPicture?Image.file(File(snapshot.data.currentItem.picture),fit: BoxFit.cover,):Image(image: NetworkImage(snapshot.data.currentItem.picture), fit: BoxFit.cover)),
                      Container(
                          width: MediaQuery.of(context).size.width-32,
                          height: (MediaQuery.of(context).size.width-32)*240/382,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromRGBO(0, 0, 0, 0),
                                    Color.fromRGBO(0, 0, 0, 0),
                                    Color.fromRGBO(69, 69, 69, 1)
                                  ]))
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          child: Text(snapshot.data.currentItem.publicationDate??"date", style: TextStyle(color: cBackground, fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w700),),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 30),
                          child: Text("${snapshot.data.currentItem.count} аудио\n${timeInfo(snapshot.data.currentItem.duration)}", style: TextStyle(color: cBackground, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: fontFamily),),
                        ),
                      ),
                      snapshot.data.currentItem.playlist == null ||snapshot.data.currentItem.playlist.length == 0?SizedBox():Align(


                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 18),
                          child: Row(
                            children: [
                              Spacer(),
                              GestureDetector(
                                behavior: HitTestBehavior.deferToChild,
                                onTap: (){
                                  context.read<GeneralController>().playerController.play(snapshot.data.currentItem.playlist);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(245, 245, 245, 0.16),
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        IconSvg(IconsSvg.play, color: cBackground, height: 38, width: 38),
                                        SizedBox(width: 10,),
                                        Text("Запустить все", style: TextStyle(color: cBackground , fontFamily: fontFamily, fontSize: 14 , fontWeight: FontWeight.w400,),),
                                        SizedBox(width: 15,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          );
        }
    );
  }
  Widget _desc(){
    return Container(
        child: StreamBuilder<CollectionsState>(
            stream: context.read<GeneralController>().collectionsController.streamCollections,
            builder: (context, snapshot) {
              return !openDesc?GestureDetector(
                behavior: HitTestBehavior.deferToChild,
                onTap: (){
                  openDesc = true;
                  setState(() {});
                },
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: 40,
                      maxHeight: 100,
                      minWidth:  MediaQuery.of(context).size.width,
                      maxWidth:  MediaQuery.of(context).size.width
                  ),
                  child: Text(snapshot.data.currentItem.description ?? "",
                    overflow: TextOverflow.fade,
                    style: TextStyle(color: cBlack,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        fontFamily: fontFamily),),
                ),
              ):GestureDetector(
                behavior: HitTestBehavior.deferToChild,
                onTap: (){
                  openDesc = false;
                  setState(() {});
                },
                child: ConstrainedBox(

                  constraints: BoxConstraints(
                      minHeight: 40,
                      maxHeight: double.maxFinite,
                      minWidth:  MediaQuery.of(context).size.width,
                      maxWidth:  MediaQuery.of(context).size.width
                  ),
                  child: Text(snapshot.data.currentItem.description ?? "",
                    overflow: TextOverflow.fade,
                    style: TextStyle(color: cBlack,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        fontFamily: fontFamily),),
                ),
              );

            }
        )
    );
  }
}
