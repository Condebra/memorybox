import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:recorder/models/AudioModel.dart';
import 'package:recorder/UI/widgets/AudioItem.dart';

class AudioPreviewGenerate extends StatefulWidget {
  final List<AudioItem> items;
  final bool isHome;
  final Color colorPlay;

  const AudioPreviewGenerate(
      {@required this.items,
      this.isHome = false,
      this.colorPlay});
  @override
  _AudioPreviewGenerateState createState() => _AudioPreviewGenerateState();
}

class _AudioPreviewGenerateState extends State<AudioPreviewGenerate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          widget.isHome
              ? (widget.items.length < 5 ? widget.items.length : 5)
              : widget.items.length, (index) {
        return Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: AudioItemWidget(
              item: widget.items[index],
              colorPlay: widget.colorPlay,
            ));
      }),
    );
  }
}
