import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recorder/models/AudioItem.dart';
import 'package:recorder/models/CollectionModel.dart';
import 'package:recorder/Rest/Audio/AudioProvider.dart';
import 'package:recorder/Rest/Playlist/PlaylistProvider.dart';
import 'package:rxdart/rxdart.dart';

class HomeState {
  List<CollectionItem> collections;
  List<AudioItem> audios;
  bool loading;
  bool errors;

  HomeState({
    @required this.collections,
    @required this.audios,
    @required this.loading,
    @required this.errors,
  });
}

class HomeController {
  Function(List<CollectionItem> list) onLoadCollections;
  Function(List<AudioItem> list) onLoadAudios;

  List<CollectionItem> collections;
  List<AudioItem> audios;

  final BehaviorSubject _streamController = BehaviorSubject<HomeState>();

  get stream => _streamController.stream;

  HomeController({this.onLoadCollections, this.onLoadAudios}) {
    load();
  }

  load() async {
    loadAudios();
    loadServerAudios();
    loadCollections();
    _streamController.sink.add(HomeState(
      collections: collections,
      audios: audios,
      loading: false,
      errors: false,
    ));
  }

  loadCollections() async {
    collections = await PlaylistProvider.getAll();
    onLoadCollections(collections);
    _streamController.sink.add(HomeState(
      collections: collections,
      audios: audios,
      loading: false,
      errors: false,
    ));
  }

  loadAudios() async {
    audios = await AudioProvider.getAudios();
    onLoadAudios(audios);
    // _streamController.sink.add(HomeState(
    //   collections: collections,
    //   audios: audios,
    //   loading: false,
    //   errors: false,
    // ));
    // _streamController.close();
  }

  loadServerAudios() async {
    var remoteAudio = await AudioProvider.getServerAudios();
    List<AudioItem> temp = [];
    audios.forEach((element) {
      if (element.idS != null)
        remoteAudio.forEach((item) {
          if (item.idS == element.idS) temp.add(item);
        });
      else
        temp.add(element);
    });
    audios
      ..clear()
      ..addAll(temp);
    onLoadAudios(audios);
    // _streamController.sink.add(HomeState(
    //   collections: collections,
    //   audios: audios,
    //   loading: false,
    //   errors: false,
    // ));
  }

  dispose() {
    _streamController.close();
  }
}
