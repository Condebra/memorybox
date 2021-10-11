import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/CollectionsState.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/widgets/Appbar.dart';
import 'package:provider/provider.dart';
import 'package:recorder/UI/widgets/AudioItem.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:recorder/models/AudioModel.dart';

class StateAddCollection extends StatefulWidget {
  @override
  _StateAddCollectionState createState() => _StateAddCollectionState();
}

class _StateAddCollectionState extends State<StateAddCollection> {

  bool editHeader = false;
  bool editComment = false;
  FocusNode focusNode =FocusNode();


  @override
  void initState() {
    // context.read<GeneralController>().collectionsController.controllerHeader.addListener(() {
    //   name = context.read<GeneralController>().collectionsController.controllerHeader.text;
    //   setState(() {});
    // });
    focusNode.addListener(() {
      if(!focusNode.hasFocus){
        editHeader = false;
      }
      setState(() {});
    });
    super.initState();
  }

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
        height: 90,
        tapLeftButton: (){
          context.read<GeneralController>().collectionsController.back();
        },
        tapRightButton:  (){
          //todo save
          context.read<GeneralController>().collectionsController.createCollection();
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
                  "Создание",
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child:
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width -42,
                        child: _header()),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              _photo(),
              SizedBox(height: 20,),

              _comment(),
              SizedBox(height: 20,),

              _audiosList(),
              SizedBox(height: 100,)
            ],
          ),
        ),
      ),

    );
  }


  Widget _header(){
    if(editHeader){
      FocusScope.of(context).autofocus(focusNode);
      return TextField(
        focusNode: focusNode,
        maxLines: 1,
        controller: context.read<GeneralController>().collectionsController.controllerHeader,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 24,
            color: cBackground.withOpacity(0.7),
            fontWeight: FontWeight.w700,
          ),
          hintText: "Название",
        ),
        style: TextStyle(
            color: cBackground,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontFamily: fontFamily),
      );
    }else{
      return GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: (){
          editHeader = true;
          setState(() {

          });
        },
        child: Text(context.read<GeneralController>().collectionsController.controllerHeader.text == ""?"Название":context.read<GeneralController>().collectionsController.controllerHeader.text, style: TextStyle(
          fontSize: 24,
          color: cBackground,
          fontWeight: FontWeight.w700,
        ),),
      );
    }
  }
  Widget _photo(){
    return StreamBuilder<String>(
      stream: context.read<GeneralController>().collectionsController.streamPhoto,
      builder: (context, snapshot) {
        return GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: (){
            context.read<GeneralController>().collectionsController.addImage();
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
              child: !snapshot.hasData || snapshot.data == null?Center(child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    border: Border.all(color: cBlack)
                  ),
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconSvg(IconsSvg.camera, color: cBlack),
              )),):Image.file(File(snapshot.data), fit: BoxFit.cover,),
            ),
          ),
        );
      }
    );
  }
  Widget _comment(){
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: cGreen.withOpacity(0.2)),
        ),
      ),
      child: TextField(
        minLines: 5,
        maxLines: 100,
        controller:  context.read<GeneralController>().collectionsController.controllerComment,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 14,
            color: cBlack.withOpacity(0.7),
            fontWeight: FontWeight.w400,
          ),
          hintText: "Введите описание...",
        ),
        style: TextStyle(
            color: cBlack,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: fontFamily),
      ),
    );
  }

  Widget _audiosList(){
    return StreamBuilder<CollectionsState>(
        stream: context.read<GeneralController>().collectionsController.streamCollections,
        builder: (context, snapshot) {
          List<AudioItem> list = [];
          if(snapshot.hasData){
            if(snapshot.data.audios != null && snapshot.data.audios.isNotEmpty){
              list = snapshot.data.audios;
            }
          }
          if(list == null || list.isEmpty){
            return Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.deferToChild,
                  onTap: (){
                    context.read<GeneralController>().collectionsController.addAudio();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: cBlack.withOpacity(0.8)),
                      ),
                    ),
                    child: Text("Добавить аудиофайл" , style: TextStyle(color: cBlack, fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w400),),
                  ),
                ),
              ),
            );
          }else
            return Column(
              children: [
                Column(
                  children: List.generate(list.length, (index) {
                    return Column(
                      children: [
                        AudioItemWidget(
                          colorPlay: cSwamp,
                          selected: false,
                          onSelect: (){
                            //todo select
                          },
                          item: list[index],
                        ),
                        SizedBox(height: 10,),
                      ],
                    );
                  }),
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: GestureDetector(
                      behavior: HitTestBehavior.deferToChild,
                      onTap: (){
                        context.read<GeneralController>().collectionsController.addAudio();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1, color: cBlack.withOpacity(0.8)),
                          ),
                        ),
                        child: Text("Добавить аудиофайл" , style: TextStyle(color: cBlack, fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w400),),
                      ),
                    ),
                  ),
                )
              ],
            );
        }
    );
  }



}
