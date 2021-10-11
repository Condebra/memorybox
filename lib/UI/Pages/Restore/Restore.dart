import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/RestoreState.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/widgets/Appbar.dart';
import 'package:provider/provider.dart';
import 'package:recorder/UI/widgets/AudioItem.dart';
import 'package:recorder/Utils/DropMenu/DropMenuItem.dart';
import 'package:recorder/Utils/DropMenu/FocusedMunu.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';


class Restore extends StatefulWidget {
  @override
  _RestoreState createState() => _RestoreState();
}

class _RestoreState extends State<Restore> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<GeneralController>().restoreController.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackground.withOpacity(0.0),
      appBar: MyAppBar(
        buttonMore: true,
        buttonBack: false,
        buttonMenu: true,
        tapLeftButton: (){
          context.read<GeneralController>().setMenu(true);
        },
        childRight: FocusedMenuHolder(
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
                context.read<GeneralController>().restoreController.setSelect(true);
              }, title: Text("Выбрать несколько",style: TextStyle(color: cBlack, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: fontFamily),),),
              FocusedMenuItem(onPressed: (){
                context.read<GeneralController>().restoreController.deleteAll();
              }, title: Text("Удалить все",style: TextStyle(color: cBlack, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: fontFamily),),),
              FocusedMenuItem(onPressed: (){
                context.read<GeneralController>().restoreController.restoreAll();

              }, title: Text("Восстановить все",style: TextStyle(color: cBlack, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: fontFamily),),),
            ],
            onPressed: (){},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 11),
              child: Container(
                width: 27,
                height: 27,
                child: Center(
                  child: IconSvg(IconsSvg.more,
                      width: 41, height: 8, color: cBackground),
                ),
              ),
            )),

        top: 25,
        height: 100,
        child: Container(
          child: Column(
            children: [
              Text(
               "Недавно\nудаленные",
                textAlign: TextAlign.center,
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
      body: StreamBuilder<RestoreState>(
        stream: context.read<GeneralController>().restoreController.streamRestore,
        builder: (context, snapshot) {
          if(!snapshot.hasData || snapshot.data.loading){
            return Center(child: CircularProgressIndicator(),);
          }else if(snapshot.data.items == null || snapshot.data.items.isEmpty){
            return _empty();
          }else {
            return SingleChildScrollView(
              child: snapshot.data.select
                  ? _contentSelected(snapshot.data)
                  : _content(snapshot.data),
            );
          }
        }
      ),
    );
  }

  Widget _content(RestoreState state){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: List.generate(state.items.length, (index){
          return Column(
            children: [
              AudioItemWidget(
                colorPlay: cBlue,
                selected: false,
                delete: true,
                item: state.items[index],
              ),
              SizedBox(height: 10,),
            ],
          );
        }),
      ),
    );
  }

  _contentSelected(RestoreState state){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.deferToChild,
                  onTap: (){
                  print("tap");
                  context.read<GeneralController>().restoreController.setSelect(false);
                  },
                  child: Text("Отменить", style: TextStyle(color: cBackground, fontFamily: fontFamily,fontSize: 16, fontWeight: FontWeight.w400),))
            ],
          ),
          SizedBox(height: 20,),
          Column(
            children: List.generate(state.items.length, (index){
              return Column(
                children: [
                  AudioItemWidget(
                    colorPlay: cBlue,
                    selected: true,
                    onSelect: (){
                      context.read<GeneralController>().restoreController.tapSelect(state.items[index]);
                      },
                    item: state.items[index],
                  ),
                  SizedBox(height: 10,),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
  Widget _empty(){
    return Center(
      child: Text('Тут пусто', style: TextStyle(color: cBlack.withOpacity(0.7), fontWeight: FontWeight.w700, fontSize: 20, fontFamily: fontFamily),),
    );
  }
}
