import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:provider/provider.dart';
class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: cBackground,
          borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        ),
        width: MediaQuery.of(context).size.width*0.60,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Spacer(),
                  Spacer(),
                  Text("Аудиосказки", style: TextStyle(color: cBlack, fontFamily: fontFamily, fontSize: 24, fontWeight: FontWeight.w400),),
                  Spacer(),
                  Text("Меню", style: TextStyle(color: cBlack.withOpacity(0.5), fontWeight: FontWeight.w400, fontSize: 22, fontFamily: fontFamily),),
                  Spacer(),
                  Spacer(),
                  Spacer(),

                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.7,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    item(IconSvg(IconsSvg.home, height: 30, width: 30, color: cBlack), "Главная", onTap: (){
                      context.read<GeneralController>().setPage(0);
                      context.read<GeneralController>().setMenu(false);

                    }),
                    item(IconSvg(IconsSvg.profile, height: 30, width: 30, color: cBlack), "Профиль", onTap: (){
                      context.read<GeneralController>().setPage(4);
                      context.read<GeneralController>().setMenu(false);

                    }),
                    item(IconSvg(IconsSvg.category, height: 30, width: 30, color: cBlack), "Подборки", onTap: (){
                      context.read<GeneralController>().setPage(1);
                      context.read<GeneralController>().setMenu(false);

                    }),
                    item(IconSvg(IconsSvg.paper, height: 30, width: 30, color: cBlack), "Все аудиофайлы", onTap: (){
                      context.read<GeneralController>().setPage(3);
                      context.read<GeneralController>().setMenu(false);


                    }),
                    item(IconSvg(IconsSvg.search, height: 30, width: 30, color: cBlack), "Поиск", onTap: (){
                      context.read<GeneralController>().setPage(5, restore: true);

                    }),
                    item(IconSvg(IconsSvg.delete, height: 30, width: 30, color: cBlack), "Недавно удаленные", onTap: (){
                      context.read<GeneralController>().setPage(2, restore: true);
                      context.read<GeneralController>().setMenu(false);
                    }),
                    // SizedBox(height: 30,),
                    item(IconSvg(IconsSvg.wallet, height: 30, width: 30, color: cBlack), "Подписка", onTap: (){
                      context.read<GeneralController>().openSubscribe();
                      context.read<GeneralController>().setMenu(false);

                    }),
                    SizedBox(height: 30,),

                    item(IconSvg(IconsSvg.edit, height: 30, width: 30, color: cBlack), "Написать в поддержку", onTap: (){
                      context.read<GeneralController>().support();
                    }),
                  ],
                ),
              ),
            )


          ],
        ),
      ),
    );
  }


  Widget item( Widget icon, String text, {Function onTap,}){
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: (){
        if(onTap != null) onTap();
      },
      child: Container(
        width: MediaQuery.of(context).size.width*0.6,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(width: 40,),
              Container(width: 30, height: 30,child: icon,),
              SizedBox(width: 15,),
              Container(
                  width: MediaQuery.of(context).size.width*0.6-40-30-15-10,
                  child: Text(text, style: TextStyle(color: cBlack, fontWeight: FontWeight.w400,fontSize: 14, fontFamily: fontFamily, ),))
            ],
          ),
        ),
      ),
    );
  }
}
