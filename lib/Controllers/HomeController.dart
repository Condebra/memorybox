import 'dart:developer';
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

  List<CollectionItem> collections = [];
  List<AudioItem> audios = [];

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
  }

  loadServerAudios() async {
    var remoteAudio = await AudioProvider.getServerAudios();
    List<AudioItem> allAudios = [];
    allAudios
      ..addAll(audios)
      ..addAll(remoteAudio.reversed);
    Map<String, AudioItem> map = {};
    for (var item in allAudios) {
      map[item.name] = item;
    }
    var filtered = map.values.toList();
    // filtered.forEach((element) {
    //   log("${element.toMap()}", name: "filtered");
    // });
    // filtered.sort(())
    audios
      ..clear()
      ..addAll(filtered);
    onLoadAudios(audios);
  }

  dispose() {
    _streamController.close();
  }
}
