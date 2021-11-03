import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recorder/Controllers/CollectionsController.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/widgets/Appbar.dart';
import 'package:provider/provider.dart';
import 'package:recorder/UI/widgets/AudioItem.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool hasFocus = false;

  TextEditingController controllerText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.sync(context.read<GeneralController>().onWillPop),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: cBackground.withOpacity(0.0),
          appBar: MyAppBar(
            buttonMore: false,
            buttonBack: false,
            buttonMenu: true,
            padding: 11,
            height: 90,
            tapLeftButton: (){
              context.read<GeneralController>().setMenu(true);
            },
            child: Container(
              child: Column(
                children: [
                  Text(
                    "Поиск",
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        fontFamily: fontFamilyMedium,
                        letterSpacing: 2),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Найди потеряшку",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: fontFamilyMedium,
                        letterSpacing: 2),
                  )
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 40),
            child: Column(
              children: [
                SizedBox(height: 40,),
                searchField(),
                hint(),
                listResult(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchField(){
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 12),
      child: Container(
        decoration: BoxDecoration(
            color: cBackground,
            borderRadius: BorderRadius.all(Radius.circular(50))
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 6, right: 6, bottom: 6, left: 18),
          child: Focus(
            onFocusChange: (hasFocus){
              setState(() {
                this.hasFocus = hasFocus;
              });
            },
            child: TextField(
              controller: controllerText,
              onChanged: (str){
                context.read<GeneralController>().collectionsController.search(str);
              },
              style:TextStyle(
                color: cBlack.withOpacity(1),
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: fontFamily,
              ) ,
              decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10, top: 8, bottom: 10 ),
                    child: IconSvg(IconsSvg.search, height: 22, width: 22),
                  ),
                  // contentPadding: EdgeInsets.all(0),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: "Поиск",
                  hintStyle: TextStyle(
                    color: cBlack.withOpacity(0.5),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: fontFamily,
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget hint(){
    if(hasFocus){
      return StreamBuilder<StateSearch>(
          stream: context.read<GeneralController>().collectionsController.streamSearch,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              if(snapshot.data.results.isEmpty)return SizedBox();
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 12, top: 20),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: cBackground,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.18),
                          offset: Offset(0,4),
                          blurRadius: 20,
                          spreadRadius: 0,
                        ),
                      ]
                  ),
                  child: Column(
                    children: List.generate(snapshot.data.results.length.clamp(0,3), (index) {
                      return InkWell(
                        onTap: (){
                          controllerText.text = snapshot.data.results[index].name;
                          controllerText.selection = TextSelection.fromPosition(TextPosition(offset: controllerText.text.length));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                          child: Row(
                            children: [
                              Text(
                                snapshot.data.results[index].name,
                                style: TextStyle(color: cBlack.withOpacity(1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: fontFamily),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              );
            }
            return SizedBox();
          }
      );
    }
    return SizedBox();
  }

  Widget listResult(){
    return StreamBuilder<StateSearch>(
        stream: context.read<GeneralController>().collectionsController.streamSearch,
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data.results.isNotEmpty){
            return Column(
              children: List.generate(snapshot.data.results.length, (index) {
                return Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 20 , right: 12),
                    child: AudioItemWidget(
                      item: snapshot.data.results[index],
                      colorPlay: cBlueSoso,
                    ));
              }),
            );
          }
          return SizedBox();
        }
    );
  }
}
