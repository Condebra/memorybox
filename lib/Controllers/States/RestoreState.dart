import 'package:flutter/cupertino.dart';
import 'package:recorder/models/AudioItem.dart';

class RestoreState {
  final bool select;
  final List<AudioItem> items;
  final bool loading;

  RestoreState({@required this.items, this.loading, this.select});
}
