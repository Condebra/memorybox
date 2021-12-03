import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recorder/Controllers/States/RestoreState.dart';
import 'package:recorder/DB/DB.dart';
import 'package:recorder/Rest/Audio/AudioProvider.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/Utils/DialogsIntegron/DialogIntegron.dart';
import 'package:recorder/Utils/DialogsIntegron/DialogLoading.dart';
import 'package:recorder/Utils/DialogsIntegron/DialogRecorder.dart';
import 'package:recorder/Utils/app_keys.dart';
import 'package:recorder/models/AudioItem.dart';
import 'package:recorder/models/Put.dart';
import 'package:rxdart/rxdart.dart';

class RestoreController {
  BehaviorSubject _controllerRestore = BehaviorSubject<RestoreState>();

  get streamRestore => _controllerRestore.stream;

  List<AudioItem> _items;
  bool _loading = false;
  bool _select = false;

  RestoreController() {
    _loading = true;
    setState();
    load();
  }

  load() async {
    _loading = true;
    setState();
    // _items = await AudioProvider.deleted();
    _items = await DBProvider.db.getAudios(removed: true);
    _items.addAll(await AudioProvider.deleted());
    _loading = false;
    setState();
  }

  tapSelect(AudioItem item) {
    for (int i = 0; i < _items.length; i++) {
      if (item.id == null
          ? item.idS == _items[i].idS
          : item.id == _items[i].id) {
        if (_items[i].select == null || !_items[i].select) {
          _items[i].select = true;
        } else {
          _items[i].select = false;
        }
      }
    }
    setState();
  }

  deleteSelect() async {
    Put error;
    showDialogLoading(AppKeys.scaffoldKey.currentContext);
    List<AudioItem> out = [];
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].select != null && _items[i].select) out.add(_items[i]);
    }
    out.forEach((element) {
      deleteFinal(element);
    });
    _select = false;
    await load();

    closeDialog(AppKeys.scaffoldKey.currentContext);
    if (error != null) {
      showDialogIntegronError(AppKeys.scaffoldKey.currentContext,
          "Во время удаления были  непредвиденные ошибки, попробуйте еще раз, если ошибка повторяется - обратитесь в тех поддержку");
    }
  }

  restoreSelect() async {
    Put error;
    showDialogLoading(AppKeys.scaffoldKey.currentContext);
    List<AudioItem> out = [];
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].select != null && _items[i].select) out.add(_items[i]);
    }
    out.forEach((element) async {
      await DBProvider.db.restoreAudio(element.id);
    });
    _select = false;
    await load();

    closeDialog(AppKeys.scaffoldKey.currentContext);
    if (error != null) {
      showDialogIntegronError(AppKeys.scaffoldKey.currentContext,
          "Во время удаления были  непредвиденные ошибки, попробуйте еще раз, если ошибка повторяется - обратитесь в тех поддержку");
    }
  }

  restoreAll() async {
    showDialogLoading(AppKeys.scaffoldKey.currentContext);
    Put error;
    _items.forEach((element) async {
      await DBProvider.db.restoreAudio(element.id);
    });
    _select = false;
    await load();
    closeDialog(AppKeys.scaffoldKey.currentContext);

    if (error != null) {
      showDialogIntegronError(AppKeys.scaffoldKey.currentContext,
          "Во время удаления были  непредвиденные ошибки, попробуйте еще раз, если ошибка повторяется - обратитесь в тех поддержку");
    }
  }

  deleteAll() async {
    print("a");
    showDialogLoading(AppKeys.scaffoldKey.currentContext);
    Put error;
    _items.forEach((element) async {
      deleteFinal(element);
    });
    _select = false;
    await load();
    closeDialog(AppKeys.scaffoldKey.currentContext);

    if (error != null) {
      showDialogIntegronError(AppKeys.scaffoldKey.currentContext,
          "Во время удаления были  непредвиденные ошибки, попробуйте еще раз, если ошибка повторяется - обратитесь в тех поддержку");
    }
  }

  deleteFinal(AudioItem item) async {
    try {
      var file = File(item.pathAudio);
      file.delete();
      DBProvider.db.deleteAudio(item.id);
      print("delete file ${item.pathAudio}");
    } catch (e) {
      print(e);
    }
    await load();
  }

  deleteFinalCloud({@required int ids}) async {
    try {
      AudioProvider.deleteOnCloud(ids: ids);
    } catch (e) {
      print(e);
    }
    await load();
  }

  Future<void> delete(AudioItem item, {bool fromCloud = false}) async {
    print("delete attempt ${item.toMap()}");
    showDialogRecorder(
      context: AppKeys.scaffoldKey.currentContext,
      title: Text(
        "Точно удалить?",
        style: TextStyle(
          color: cBlack,
          fontWeight: FontWeight.w400,
          fontSize: 20,
          fontFamily: fontFamily,
        ),
      ),
      body: Text(
        "Запись будет помещена в корзину, \n чтобы вы смогли её восстановить",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: cBlack.withOpacity(0.7),
          fontFamily: fontFamily,
          fontSize: 14,
        ),
      ),
      buttons: [
        DialogIntegronButton(
          onPressed: () async {
            if (fromCloud)
              await AudioProvider.deleteOnCloud(ids: item.idS);
            else
              await DBProvider.db.removeAudio(item.id);
            closeDialog(AppKeys.scaffoldKey.currentContext);
          },
          textButton: Text(
            "Да",
            style: TextStyle(
                color: cBackground,
                fontSize: 16,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w500),
          ),
          background: cRed,
          borderColor: cRed,
        ),
        DialogIntegronButton(
          onPressed: () {
            closeDialog(AppKeys.scaffoldKey.currentContext);
            return;
          },
          textButton: Text(
            "Нет",
            style: TextStyle(
                color: cBlueSoso,
                fontSize: 16,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w400),
          ),
          borderColor: cBlueSoso,
        ),
      ],
    );
  }

  deleteSeveral(List<AudioItem> items) async {
    if (items.isNotEmpty) {
      // bool findLocal = false;
      // items.forEach((element) {
      //   if (element.idS == null) findLocal = true;
      // });
      showDialogRecorder(
        context: AppKeys.scaffoldKey.currentContext,
        title: Text(
          "Точно удалить?",
          style: TextStyle(
            color: cBlack,
            fontWeight: FontWeight.w400,
            fontSize: 20,
            fontFamily: fontFamily,
          ),
        ),
        body: Text(
          "Записи будут помещены в корзину",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: cBlack.withOpacity(0.7),
            fontFamily: fontFamily,
            fontSize: 14,
          ),
        ),
        buttons: [
          DialogIntegronButton(
            onPressed: () async {
              closeDialog(AppKeys.scaffoldKey.currentContext);
              showDialogLoading(AppKeys.scaffoldKey.currentContext);
              // for (int i = 0; i < items.length; i++) {
              //   if (items[i].idS != null) {
              //     Put response = await AudioProvider.delete(items[i].id,
              //         ids: items[i].idS);
              //   }
              //   if (items[i].id != null) {
              //     await DBProvider.db.audioDelete(items[i].id);
              //   }
              // }
              items.forEach((element) async {
                await DBProvider.db.removeAudio(element.id);
              });
              closeDialog(AppKeys.scaffoldKey.currentContext);
              showDialogIntegronError(
                  AppKeys.scaffoldKey.currentContext, "Удалено");
            },
            textButton: Text(
              "Удалить",
              style: TextStyle(
                color: cBackground,
                fontSize: 16,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w500,
              ),
            ),
            background: cRed,
            borderColor: cRed,
          ),
          DialogIntegronButton(
              onPressed: () {
                closeDialog(AppKeys.scaffoldKey.currentContext);
              },
              textButton: Text(
                "Нет",
                style: TextStyle(
                  color: cBlueSoso,
                  fontSize: 16,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w400,
                ),
              ),
              borderColor: cBlueSoso),
        ],
      );
    }
  }

  setSelect(bool status) {
    if (status)
      for (int i = 0; i < _items.length; i++) {
        _items[i].select = false;
        if (_items.isNotEmpty) {
          _select = status;
        }
      }
    else {
      _select = status;
    }
    setState();
  }

  setState() {
    RestoreState state =
        RestoreState(items: _items, loading: _loading, select: _select);
    _controllerRestore.sink.add(state);
  }

  dispose() {
    _controllerRestore.close();
  }
}
