import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/models/AudioItem.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/widgets/AudioItem.dart';
import 'package:recorder/UI/widgets/AudioPreviewGenerate.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:recorder/generated/l10n.dart';
import 'package:provider/provider.dart';

class AudioPreview extends StatefulWidget {
  List<AudioItem> items;
  bool loading;

  AudioPreview({@required this.items, this.loading});

  @override
  _AudioPreviewState createState() => _AudioPreviewState();
}

class _AudioPreviewState extends State<AudioPreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width - 4,
      decoration: BoxDecoration(
          color: cBackground,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                spreadRadius: 0,
                offset: Offset(0, 4),
                blurRadius: 24,
                color: Color.fromRGBO(0, 0, 0, 0.15))
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 11),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).audios,
                    style: TextStyle(
                        color: cBlack,
                        fontSize: 24,
                        fontWeight: FontWeight.w400),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<GeneralController>().setPage(3);
                    },
                    child: Text(
                      S.of(context).open_all,
                      style: TextStyle(
                          color: cBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
            widget.loading ?? true
                ? Center(child: CircularProgressIndicator())
                : audiosPreview(context)
          ],
        ),
      ),
    );
  }

  Widget audiosPreview(BuildContext context) {
    return widget.items.isEmpty
        ? emptyAudio()
        : Container(
            // height: 86 * widget.items.length.toDouble(),
            height: 380, //if i add this its working properly
            child: Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Column(
                children: [
                  AudioPreviewGenerate(
                    isHome: true,
                    items: widget.items,
                  ),
                ],
              ),
            ),
          );
  }

  Widget emptyAudio() {
    return Container(
      height: 280,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            S.of(context).text_of_empty_audios,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w400,
                color: cBlack.withOpacity(0.5)),
          ),
          IconSvg(IconsSvg.audioArrow, width: 60, height: 60),
        ],
      ),
    );
  }
}
