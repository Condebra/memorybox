import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/PlayerState.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/Pages/Home/widgets/FirstCollectionItem.dart';
import 'package:recorder/UI/widgets/Appbar.dart';
import 'package:recorder/Utils/time/TimeParse.dart';
import 'package:recorder/models/CollectionModel.dart';
import 'package:provider/provider.dart';

class StateViewCollection extends StatefulWidget {
  List<CollectionItem> items;

  StateViewCollection({this.items});

  @override
  _StateViewCollectionState createState() => _StateViewCollectionState();
}

class _StateViewCollectionState extends State<StateViewCollection> {
  List<CollectionItem> leftColumn = [];
  List<CollectionItem> rightColumn = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < widget.items.length; i += 2) {
      try {
        leftColumn.add(widget.items[i]);
      } catch (e) {}

      try {
        rightColumn.add(widget.items[i + 1]);
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBlack.withOpacity(0.0),
      appBar: MyAppBar(
        buttonMore: false,
        buttonMenu: false,
        buttonBack: false,
        buttonAdd: true,
        padding: 18,
        top: 16,
        height: 90,
        tapLeftButton: () {
          context
              .read<GeneralController>()
              .collectionsController
              .addCollection();
        },
        child: Container(
          child: Column(
            children: [
              Text(
                "Подборки",
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
                "Все в одном месте",
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(children: [
            SizedBox(
              height: 56,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                      leftColumn.length,
                      (index) => Column(
                            children: [
                              CollectionItemOne(
                                onTap: () {
                                  context
                                      .read<GeneralController>()
                                      .collectionsController
                                      .view(leftColumn[index]);
                                },
                                item: leftColumn[index],
                              ),
                              SizedBox(height: 16)
                            ],
                          )),
                ),
                SizedBox(width: 15.5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                      rightColumn.length,
                      (index) => Column(
                            children: [
                              CollectionItemOne(
                                onTap: () {
                                  context
                                      .read<GeneralController>()
                                      .collectionsController
                                      .view(rightColumn[index]);
                                },
                                item: rightColumn[index],
                              ),
                              // SizedBox(height: 16)
                            ],
                          )),
                )
              ],
            ),
            StreamBuilder<PlayerState>(
                stream: context
                    .read<GeneralController>()
                    .playerController
                    .playerStream,
                builder: (context, snapshot) {
                  return SizedBox(
                    height: 100,
                  );
                })
          ]),
        ),
      ),
    );
  }
}
