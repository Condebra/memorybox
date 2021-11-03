
import 'package:flutter/foundation.dart';
import 'package:recorder/models/AudioModel.dart';
import 'package:recorder/models/CollectionModel.dart';

enum CollectionStates{
  view,
  editing,
  add,
  addAudio,
  viewItem,
  loading,
  select

}

class CollectionsState{
  CollectionStates stateSelect;
  List<CollectionItem> items;
  CollectionItem currentItem;
  List<AudioItem> audios;
  List<AudioItem> audiosAll;
  List<AudioItem> audiosSearch;

  CollectionsState({
    @required this.stateSelect,
    @required this.items,
    @required this.currentItem,
    @required this.audios,
    @required this.audiosSearch,
    @required this.audiosAll,
  });
}