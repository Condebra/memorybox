import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recorder/DB/DB.dart';
import 'package:recorder/Utils/checkConnection.dart';
import 'package:recorder/models/AudioItem.dart';
import 'package:recorder/models/Put.dart';
import 'package:recorder/Rest/API.dart';
import 'package:recorder/Rest/Rest.dart';
import 'package:recorder/Utils/tokenDB.dart';

class AudioProvider {
  static Future<List<AudioItem>> get({int id}) async {
    if (await futureAuth() || !await checkConnection()) {
      if (id == null) return await DBProvider.db.getAudios();
      return [await DBProvider.db.getAudio(id)];
    } else {
      String token = await tokenDB();
      String urlQuery = urlConstructor(
          id == null ? Methods.audio.getUserAudio : Methods.audio.get);
      Map<String, dynamic> body = Map();
      if (id != null) body['id'] = id;
      var response;
      response = await Rest.post(urlQuery, body, token: token);
      if (response.runtimeType.toString() == "Put") {
        Put r = response;
        if (r.code == 401) {
          tokenDB(token: "null");
          return null;
        }
        return [];
      } else {
        List<AudioItem> listS = response
            .map((i) => AudioItem.fromMap(i))
            .toList()
            .cast<AudioItem>();
        if (listS == null) {
          listS = [];
        }
        List<AudioItem> listL = await DBProvider.db.getAudios();
        if (id == null) {
          for (int i = 0; i < listS.length; i++) {
            bool find = false;

            for (int j = 0; j < listL.length; j++) {
              if (listL[j].idS != null && listS[i].idS == listL[j].idS) {
                find = true;
                break;
              }
            }
            if (!find) {
              await DBProvider.db.audioAdd(listS[i]);
            }
          }
          for (int i = 0; i < listL.length; i++) {
            bool find = false;
            if (listL[i].idS == null && !listL[i].uploadAudio) {
              // find = true;
              // int id = await upload(listL[i].name, listL[i].description,
              //     listL[i].duration.inMilliseconds, listL[i].pathAudio,
              //     image: listL[i].picture);
              if (id != null) {
                await DBProvider.db
                    .audioEdit(listL[i].id, ids: id, uploadAudio: true);
              }
            } else {
              for (int j = 0; j < listS.length; j++) {
                if (listL[i].idS == listS[j].idS) find = true;
              }
            }
            if (!find) {
              await DBProvider.db.deleteAudio(listL[i].id);
            }
          }
          return await DBProvider.db.getAudios();
        } else {
          if (listL.isEmpty) {
            await DBProvider.db.audioAdd(listS[0]);
            return listS;
          } else {
            return listL;
          }
        }
      }
    }
  }

  static Future<Put> deleteOnCloud({@required int ids}) async {
    print("DELETE AUDIO Cloud ${ids.toString()}");
    if (ids != null) {
      String urlQuery = urlConstructor(Methods.audio.delete);
      print(urlQuery);
      String token = await tokenDB();

      Map<String, dynamic> body = Map();
      body['id'] = ids;
      var response;
      response = await Rest.post(urlQuery, body, token: token);
      if (response is Put) {
        return response;
      } else {
        return Put(code: 200, message: "ok", isLocal: false);
      }
    }
    return Put(code: 400, message: "Audio is not on server", isLocal: false);
  }

  static Future<Put> create(
      String name, String description, int duration, String pathFileAudio,
      {String image}) async {
    print('save');

    if (await futureAuth() || !await checkConnection()) {
      await rootBundle.load('assets/images/play.png');

      await DBProvider.db.audioAdd(AudioItem(
          name: name,
          description: description,
          pathAudio: pathFileAudio,
          picture: image,
          isLocalAudio: true,
          uploadAudio: false,
          duration: Duration(milliseconds: duration)));
      return Put(code: 201, message: "ok", isLocal: true);
    } else {
      await DBProvider.db.audioAdd(AudioItem(
          name: name,
          description: description,
          pathAudio: pathFileAudio,
          picture: image,
          isLocalAudio: true,
          uploadAudio: false,
          duration: Duration(milliseconds: duration)));
      await syncAudio();
      // return Put(error: 201, mess: "ok", localError: true);
      String token = await tokenDB();
      String urlQuery = urlConstructor(Methods.audio.upload);
      var dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      var formData = FormData.fromMap({
        "name": name,
        "description": description,
        "duration": duration,
        "Accept": "application/json",
        "Content-Type": "multipart/form-data;",
        "audio": await MultipartFile.fromFile(pathFileAudio,
            filename: pathFileAudio.split("/").last),
        "picture": image == null
            ? MultipartFile.fromBytes(
                (await rootBundle.load('assets/images/play.png'))
                    .buffer
                    .asUint8List(),
                filename: "play.png",
              )
            : await MultipartFile.fromFile(
                image,
                filename: image.split("/").last,
              )
      });

      Response response = await dio.post(
        urlQuery,
        data: formData,
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        await DBProvider.db.audioAdd(AudioItem(
            name: name,
            description: description,
            pathAudio: pathFileAudio,
            picture: image,
            isLocalAudio: true,
            uploadAudio: true,
            duration: Duration(milliseconds: duration),
            idS: response.data['id']));
        return Put(code: 201, message: "Ok", isLocal: false);
      } else {
        return Put(code: response.statusCode, message: "", isLocal: true);
      }
    }
  }

  static Future<List<AudioItem>> deleted() async {
    if (await futureAuth()) {
      return [];
    } else {
      String token = await tokenDB();
      String urlQuery = urlConstructor(Methods.audio.deleted);
      Map<String, dynamic> body = Map();
      var response;
      response = await Rest.post(urlQuery, body, token: token);
      if (response.runtimeType.toString() == "Put") {
        Put r = response;
        if (r.code == 401) {
          tokenDB(token: "null");
          return null;
        }
        return [];
      } else {
        return response
            .map((i) => AudioItem.fromMap(i))
            .toList()
            .cast<AudioItem>();
      }
    }
  }

  static Future<Put> restore(int ids) async {
    String urlQuery = urlConstructor(Methods.audio.restore);
    String token = await tokenDB();
    print(urlQuery);

    Map<String, dynamic> body = Map();
    body['id'] = ids;
    var response;
    response = await Rest.post(urlQuery, body, token: token);
    if (response is Put) {
      return response;
    } else {
      return Put(code: 200, message: "ok", isLocal: false);
    }
  }

  static Future<Put> editOnlyS(int id,
      {String name, String desc, String imagePath}) async {
    // log("$id", name: "id");
    AudioItem item = await DBProvider.db.getAudio(-1, idS: id);
    String urlQuery = urlConstructor(Methods.audio.edit);
    String token = await tokenDB();
    Map<String, dynamic> body = Map();
    body['id'] = item.idS;
    if (imagePath != null)
      body['picture'] = await MultipartFile.fromFile(imagePath,
          filename: imagePath.split("/").last);
    if (name != null) body['name'] = name;
    if (desc != null) body['description'] = desc;
    var dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    var formData = FormData.fromMap(body);
    Response response = await dio.post(
      urlQuery,
      data: formData,
    );
    // log("${response.data}", name: "response");
    if (response.statusCode == 200) {
      return Put(code: 200, message: "Ok", isLocal: false);
    } else {
      return Put(code: response.statusCode, message: "", isLocal: true);
    }
  }

  static Future<List<AudioItem>> syncAudio() async {
    if (await futureAuth() || await checkConnection()) {
      return await DBProvider.db.getAudios();
    } else {
      String token = await tokenDB();
      String urlQuery = urlConstructor(Methods.audio.getUserAudio);
      Map<String, dynamic> body = Map();
      var response;
      response = await Rest.post(urlQuery, body, token: token);
      List<AudioItem> listS =
          response.map((i) => AudioItem.fromMap(i)).toList().cast<AudioItem>();
      if (listS == null) {
        listS = [];
      }
      List<AudioItem> listL = await DBProvider.db.getAudios();
      for (int i = 0; i < listS.length; i++) {
        bool find = false;
        for (int j = 0; j < listL.length; j++) {
          if (listL[j].idS != null && listL[j].idS == listS[i].idS) {
            if (listL[j].updateAt.isBefore(listS[i].updateAt)) {
              await DBProvider.db.audioEdit(listL[j].id,
                  name: listS[i].name,
                  desc: listS[i].description,
                  picture: listS[i].picture,
                  isLocalPicture: false,
                  uploadPicture: true);
              find = true;
            } else {
              await editOnlyS(listL[j].id,
                  name: listL[j].name,
                  desc: listL[j].description,
                  imagePath: listL[j].isLocalPicture ? listL[j].picture : null);
            }
          }
          if (!find) {
            DBProvider.db.audioAdd(AudioItem(
              name: listS[i].name,
              description: listS[i].description,
              pathAudio: listS[i].pathAudio,
              picture: listS[i].picture,
              isLocalPicture: false,
              uploadPicture: true,
              isLocalAudio: false,
              uploadAudio: true,
            ));
          }
        }
      }
      return await DBProvider.db.getAudios();
    }
  }

  static Future<List<AudioItem>> getServerAudios() async {
    List<AudioItem> list = [];
    if (!await futureAuth() && await checkConnection()) {
      String token = await tokenDB();
      String urlQuery = urlConstructor(Methods.audio.getUserAudio);
      Map<String, dynamic> body = Map();
      // print("-=-=-=-=-=-" + urlQuery);
      var response;
      try {
        response = await Rest.post(urlQuery, body, token: token);
        list.addAll(response
            .map((i) => AudioItem.fromMap(i))
            .toList()
            .cast<AudioItem>());
      } catch (e) {
        print(e);
      }
      // if (listS == null) {
      //   listS = [];
      // }
      // List<AudioItem> listL = await DBProvider.db.getAudios();
      // List<AudioItem> listOut = listL;
      // for (int i = 0; i < listS.length; i++) {
      //   bool find = false;
      //   for (int j = 0; j < listL.length; j++) {
      //     if (listL[j].idS != null && listL[j].idS == listS[i].idS) find = true;
      //   }
      //   if (!find) {
      //     listOut.add(listS[i]);
      //   }
      // }
      // listL.forEach((element) => {
      //   if (!listS.contains(element)) listS.add(element)
      // });
      // return listOut;
    }
    return list;
  }

  /// Новая версия
  static Future<List<AudioItem>> getAudios() async {
    return await DBProvider.db.getAudios();
  }

  static Future<int> createLocal(
      String name, String description, int duration, String pathFileAudio,
      {String image, int ids}) async {
    print('save audio locally');
    return await DBProvider.db.audioAdd(
      AudioItem(
        name: name,
        idS: ids,
        description: description,
        pathAudio: pathFileAudio,
        picture: image,
        isLocalAudio: true,
        uploadAudio: false,
        duration: Duration(milliseconds: duration),
      ),
    );
  }

  static Future<int> getId(String name) async {
    return await DBProvider.db.getIdByName(name);
  }

  static Future<int> upload(int id, {AudioItem audioItem}) async {
    // print('upload Audio, ${audioItem.toMap()}');

    AudioItem item = audioItem ?? await DBProvider.db.getAudio(id);

    String token = await tokenDB();
    String urlQuery = urlConstructor(Methods.audio.upload);
    var dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    var formData = FormData.fromMap({
      "name": item.name,
      "description": item.description,
      "duration": item.duration.inMilliseconds,
      "Accept": "application/json",
      "Content-Type": "multipart/form-data;",
      "audio": await MultipartFile.fromFile(item.pathAudio,
          filename: item.pathAudio.split("/").last),
      "picture": item.picture == null
          ? MultipartFile.fromBytes(
              (await rootBundle.load('assets/images/play.png'))
                  .buffer
                  .asUint8List(),
              filename: "play.png")
          : await MultipartFile.fromFile(item.picture,
              filename: item.picture.split("/").last)
    });

    Response response = await dio.post(
      urlQuery,
      data: formData,
    );
    if (audioItem == null)
      await DBProvider.db.audioEdit(id, ids: response.data['id']);
    else
      await DBProvider.db.audioEdit(
        audioItem.id,
        ids: response.data['id'],
        pathAudio: response.data['url'],
        picture: response.data['picture'],
        isLocalAudio: false,
        isLocalPicture: false,
        uploadAudio: true,
        uploadPicture: true,
      );

    if (response.statusCode == 201) {
      return response.data['id'];
    } else {
      return null;
    }
  }

  static Future<Put> edit(int id,
      {bool isLocal = true, String name, String desc, String imagePath}) async {
    if (name != null || desc != null || imagePath != null) {
      if (isLocal) {
        await DBProvider.db.audioEdit(
          id,
          name: name,
          desc: desc,
          picture: imagePath,
          isLocalPicture: true,
        );
      } else {
        await editOnlyS(id, name: name, desc: desc, imagePath: imagePath);
      }
      return Put(code: 200, message: "ok", isLocal: true);
    }
    return Put(code: 200, message: "ok", isLocal: true);
  }

  static Future<AudioItem> getFromServer(int idS) async {
    String token = await tokenDB();
    String urlQuery = urlConstructor(Methods.audio.get);
    Map<String, dynamic> body = Map();
    body['id'] = idS;
    var response;
    response = await Rest.post(urlQuery, body, token: token);
    if (response.runtimeType.toString() == "Put") {
      Put r = response;
      if (r.code == 401) {
        tokenDB(token: "null");
        return null;
      }
      return null;
    } else {
      // log("${AudioItem.fromMap(response).toMap()}", name: "145");
      return AudioItem.fromMap(response);
    }
  }
}
