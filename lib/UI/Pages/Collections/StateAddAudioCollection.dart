import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/CollectionsState.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/widgets/Appbar.dart';
import 'package:recorder/UI/widgets/AudioItem.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:recorder/models/AudioItem.dart';
import 'package:recorder/generated/l10n.dart';

class StateAddAudioCollection extends StatefulWidget {
  @override
  _StateAddAudioCollectionState createState() =>
      _StateAddAudioCollectionState();
}

class _StateAddAudioCollectionState extends State<StateAddAudioCollection> {
  List<AudioItem> list = [];

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
        padding: 10,
        top: 25,
        height: 90,
        childRight: IconButton(
          onPressed: () {
            context.read<GeneralController>().collectionsController.back();
          },
          icon: Icon(Icons.done),
        ),
        tapLeftButton: () {
          context.read<GeneralController>().collectionsController.back();
        },
        child: Container(
          child: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Text(
                  S.current.choose,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    fontFamily: fontFamilyMedium,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Column(
            children: [
              search(),
              SizedBox(
                height: 40,
              ),
              _audios()
            ],
          ),
        ),
      ),
    );
  }

  Widget search() {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      decoration: BoxDecoration(
        color: cBackground,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            SizedBox(
              width: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 32 - 30 - 50 - 10,
              child: TextField(
                controller: context
                    .read<GeneralController>()
                    .collectionsController
                    .controllerSearch,
                maxLines: 1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: 20,
                    color: cBlack.withOpacity(0.5),
                    fontWeight: FontWeight.w400,
                  ),
                  hintText: "Поиск",
                ),
                style: TextStyle(
                  color: cBlack,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 30,
              height: 30,
              child: iconSvg(IconsSvg.search),
            ),
          ],
        ),
      ),
    );
  }

  Widget _audios() {
    return StreamBuilder<CollectionsState>(
      stream: context
          .read<GeneralController>()
          .collectionsController
          .streamCollections,
      builder: (context, snapshot) {
        List<AudioItem> list = [];
        if (snapshot.hasData) {
          if (snapshot.data.audiosSearch != null &&
              snapshot.data.audiosSearch.isNotEmpty) {
            list = snapshot.data.audiosSearch;
          } else {
            list = snapshot.data.audiosAll;
          }
        }
        if (list == null || list.isEmpty)
          return Center(
            child: Text(S.current.no_audio),
          );
        return Column(
          children: List.generate(list.length, (index) {
            return Column(
              children: [
                AudioItemWidget(
                  colorPlay: cSwamp,
                  selected: true,
                  onSelect: () {
                    context
                        .read<GeneralController>()
                        .collectionsController
                        .selectAudio(list[index], index);
                  },
                  item: list[index],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
