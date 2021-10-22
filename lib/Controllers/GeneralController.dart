import 'dart:async';
import 'package:recorder/Controllers/CollectionsController.dart';
import 'package:recorder/Controllers/RestoreController.dart';
import 'package:recorder/UI/Pages/Subscription/SubscritionPage.dart';
import 'package:recorder/UI/Player.dart';
import 'package:rxdart/rxdart.dart';
import 'States/PlayerState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:recorder/Controllers/HomeController.dart';
import 'package:recorder/Controllers/PlayerController.dart';
import 'package:recorder/Controllers/ProfileController.dart';
import 'package:recorder/Controllers/RecordController.dart';
import 'package:recorder/UI/Pages/Record/showRecord.dart';
import 'package:recorder/Utils/app_keys.dart';
import 'package:recorder/models/AudioModel.dart';
import 'package:url_launcher/url_launcher.dart';

part 'States/RecordState.dart';

class GeneralController {
  ///Home
  HomeController homeController;

  ///Player
  PlayerController playerController;

  ///Profile
  ProfileController profileController;

  ///Recorder
  RecordController recordController;

  ///Collections
  CollectionsController collectionsController;

  ///Restore
  RestoreController restoreController;

  ///Pages
  PageController pageController = PageController(initialPage: 0);

  final _streamControllerPage = StreamController<int>.broadcast();

  get streamCurrentPage => _streamControllerPage.stream;

  BehaviorSubject _controllerMenu = BehaviorSubject<bool>();

  get streamMenu => _controllerMenu.stream;

  bool resume = false;

  List pageHistory = [0];

  GeneralController() {
    _controllerMenu.sink.add(false);
    this.collectionsController = CollectionsController(loadCollections);
    this.profileController = ProfileController();
    this.homeController = HomeController(onLoadCollections: (list) {
      this.collectionsController.setCollections(list);
    }, onLoadAudios: (list) {
      this.collectionsController.setAudios(list);
    });
    this.playerController = PlayerController();
    this.recordController = RecordController();
    this.restoreController = RestoreController();
  }

  loadCollections() {
    this.homeController.load();
  }

  setPage(int index, {bool restore, BuildContext context}) async {
    if (index != 2 || restore != null) {
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      _streamControllerPage.sink.add(index);
      pageHistory.add(index);
    } else {
      if (playerController.playing != null && playerController.playing) {
        await recordController.save();
        playerController.pause();
        playerController.setHide(false);
        resume = true;
      } else
        resume = false;

      recordController.recordStart(
          (MediaQuery.of(AppKeys.scaffoldKey.currentContext).size.width * 0.98) ~/ 3);
      showRecord(this);
    }
  }

  bool onWillPop() {
    if (pageHistory.length == 1 && pageController.page == 0) return true;
    if (pageHistory.isNotEmpty) {
      if (pageHistory.length > 1)
        pageHistory.removeAt(pageHistory.length - 1);
      print(pageHistory);
      pageController.animateToPage(pageHistory.last,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
      );
      _streamControllerPage.sink.add(pageHistory.last);
    }
    return false;
  }

  closeRecord() {
    if (resume) {
      playerController.setHide(true);
      playerController.resume();
      resume = false;
    }
    recordController.closeSheet();
  }

  setMenu(bool status) {
    _controllerMenu.sink.add(status);
  }

  openPlayer() {
    showPlayer(this);
  }

  openSubscribe() async {
    //todo
    pageController.jumpToPage(4);
    setMenu(false);
    Navigator.push(AppKeys.navigatorKey.currentContext,
        MaterialPageRoute(builder: (context) => SubscriptionPage()));
  }

  support() async {
    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'love@hugsy.ru',
        queryParameters: {'subject': ''});
    launch(_emailLaunchUri.toString());
  }

  dispose() {
    _streamControllerPage.close();
    homeController.dispose();
    profileController.dispose();
    playerController.dispose();
    recordController.dispose();
    collectionsController.dispose();
    _controllerMenu.close();
  }
}
