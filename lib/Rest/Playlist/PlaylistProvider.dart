import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recorder/DB/DB.dart';
import 'package:recorder/Utils/checkConnection.dart';
import 'package:recorder/models/AudioItem.dart';
import 'package:recorder/models/CollectionModel.dart';
import 'package:recorder/models/Put.dart';
import 'package:recorder/Rest/API.dart';
import 'package:recorder/Rest/Rest.dart';
import 'package:recorder/Utils/tokenDB.dart';

class PlaylistProvider {
  static Future<List<dynamic>> get({int id, int ids}) async {
    if (await futureAuth() || !await checkConnection()) {
      if (id == null) {
        return await DBProvider.db.getCollections();
      } else {
        return (await DBProvider.db.collectionGet(id)).playlist;
      }
    } else {
      if (id == null) {
        List<CollectionItem> listL = await DBProvider.db.getCollections();
        List<CollectionItem> listS;
        String token = await tokenDB();
        String urlQuery = urlConstructor(Methods.playlist.get);
        Map<String, dynamic> body = Map();
        var response;
        response = await Rest.post(urlQuery, body, token: token);
        if (response is Put) {
          if (response.code == 401) {
            tokenDB(token: "null");
            return null;
          }
          return [];
        } else {
          listS = response
              .map((i) => CollectionItem.fromMap(i))
              .toList()
              .cast<CollectionItem>();
        }
        for (int i = 0; i < listS.length; i++) {
          bool find = false;
          for (int j = 0; j < listL.length; j++) {
            if (listL[j].idS != null && listL[j].idS == listS[i].idS) {
              find = true;
              break;
            }
          }
          if (!find) {
            await DBProvider.db.collectionAdd(listS[i]);
          }
        }

        for (int i = 0; i < listL.length; i++) {
          if (listL[i].idS == null) {
            int id = await createOnlyS(
                listL[i].name, listL[i].description, listL[i].picture);
            if (id != null) {
              await DBProvider.db.collectionEdit(listL[i].id, ids: id);
            }
          }
          for (int j = 0; j < listS.length; j++) {}
        }
        print("collection get returned collections");
        return DBProvider.db.getCollections();
      } else {
        print("collection get returned audios");

        String token = await tokenDB();
        String urlQuery =
            urlConstructor(Methods.playlist.getAudioFromPlaylist(id));
        Map<String, dynamic> body = Map();
        body['id'] = ids ?? (await DBProvider.db.collectionGet(id)).idS;
        var response;
        response = await Rest.post(urlQuery, body, token: token);
        print(response.runtimeType);
        if (response.runtimeType.toString() == "Put") {
          Put r = response;
          if (r.code == 401) {
            tokenDB(token: "null");
            return null;
          }
          return [] as List<AudioItem>;
        }
        return response['audios']
            .map((i) => AudioItem.fromMap(i))
            .toList()
            .cast<AudioItem>();
      }

      // String token = await tokenDB();
      // String urlQuery = urlConstructor(
      //     id != null ? Methods.playlist.getAudioFromPlaylist(id) : Methods
      //         .playlist.get);
      // Map <String, dynamic> body = Map();
      // if (id != null) body['id'] = id;
      // var response;
      // response = await Rest.post(urlQuery, body, token: token);
      // print(response.runtimeType);
      // if (response.runtimeType.toString() == "Put") {
      //   Put r = response;
      //   if (r.error == 401) {
      //     tokenDB(token: "null");
      //     return null;
      //   }
      //   return [];
      // } else {
      //   if (id == null)
      //     return response.map((i) => CollectionItem.fromMap(i)).toList().cast<
      //         CollectionItem>();
      //   return response['audios'].map((i) => AudioItem.fromMap(i))
      //       .toList()
      //       .cast<AudioItem>();
      // }
    }
  }

  static Future<Put> addAudio(int idPlaylist, List<int> audio) async {
    if (await futureAuth()) {
      // for (int i = 0; i < audio.length; i++) {
        await DBProvider.db.collectionAddAudio(idPlaylist, audio);
      // }
      return Put(code: 201, message: "ok", isLocal: true);
    } else {
      CollectionItem collectionItem =
          await DBProvider.db.collectionGet(idPlaylist);

      String token = await tokenDB();
      String urlQuery = urlConstructor(Methods.playlist.addTo);
      Map<String, dynamic> body = Map();
      body['id'] = collectionItem.idS;

      var response = await Rest.post(urlQuery, body, token: token);
      print(response.runtimeType);
      if (response.runtimeType.toString() == "Put") {
        Put r = response;
        if (r.code == 401) {
          tokenDB(token: "null");
          return null;
        } else {
          return Put(code: 201, message: "ok", isLocal: false);
        }
      } else {
        return Put(code: 201, message: "ok", isLocal: false);
      }
    }
  }

  static Future<Put> addAudioToPlaylist(int idPlaylist, List<int> idAudio,
      {bool isLocalPlaylist = true, bool isLocalAudio = true}) async {
    //todo
    if (!isLocalPlaylist) {
      if (isLocalAudio) {
        print("Попытка добавить локальное аудио в плейлист на сервере");
        return Put(code: 500, message: "ok", isLocal: false);

        // CollectionItem item = await getFromId(idS: idPlaylist);
        // var response = await http.get(item.picture);
        // Directory documentDirectory = await getApplicationDocumentsDirectory();
        // String pathImage = join(documentDirectory.path, '${idPlaylist}playlistimage.png');
        // File file = new File(pathImage);
        // file.writeAsBytesSync(response.bodyBytes);
        // item.picture = pathImage;
        // item.isLocalPicture = true;
        // int idLocal = await DBProvider.db.collectionAdd(item);
        // await DBProvider.db.collectionAddAudio(idLocal, idAudio);
        // return Put(error: 201, mess: "ok", localError: false);
      } else {
        String token = await tokenDB();
        String urlQuery = urlConstructor(Methods.playlist.addTo);
        Map<String, dynamic> body = Map();
        body['id'] = idPlaylist;
        var response;
        response = await Rest.post(urlQuery, body, token: token);
        print(response.runtimeType);
        if (response.runtimeType.toString() == "Put") {
          Put r = response;
          if (r.code == 401) {
            tokenDB(token: "null");
            return null;
          } else {
            return Put(code: 201, message: "ok", isLocal: false);
          }
        } else {
          return Put(code: 201, message: "ok", isLocal: false);
        }
      }
    } else {
      if (isLocalAudio) {
        await DBProvider.db.collectionAddAudio(idPlaylist, idAudio, append: true);
        return Put(code: 201, message: "ok", isLocal: false);
      } else {
        // print("попИт ка  добавить  аудио на сервере в локальный плейлист ");
        return Put(code: 500, message: "ok", isLocal: false);

        ///будут выгружены все аудио
        ///--------v2
        // CollectionItem collectionItem = await DBProvider.db.collectionGet(idPlaylist);
        // if(collectionItem == null)return Put(error: 500, mess:"Не удалось получить данные подборки", localError: true );
        // createOnlyS(collectionItem.name, collectionItem.description, collectionItem.picture);
        ///--------v1
        // AudioItem audioItem = await AudioProvider.getFromServer(idAudio);
        // if(audioItem == null)return Put(error: 500, mess:"Не удалось получить данные аудио", localError: true );
        // var response = await http.get(audioItem.picture);
        // Directory documentDirectory = await getApplicationDocumentsDirectory();
        // String pathImage = join(documentDirectory.path, '${idPlaylist}audioItem.png');
        // File file = new File(pathImage);
        // file.writeAsBytesSync(response.bodyBytes);

      }
    }
  }

  static addAudioToServerPlaylist({@required int audio, @required int playlist}) async {
    if (audio != null && playlist != null) {
      final _dio = Dio();
      String token = await tokenDB();
      var url = urlConstructor(Methods.playlist.addTo);
      var body = {"audio": audio, "id": playlist};
      _dio.options.headers['Authorization'] = 'Bearer $token';
      Response response;
      try {
        response = await _dio.post(url, data: body);
        // if (response.statusCode != 200)
        //   log("${response.statusCode} - ${response.data}",
        //       name: "add audio to playlist");
      } catch (e) {
        log("Error $e", name: "add audio to playlist");
      }
    }
  }

  static Future<void> edit(int id,
      {String name, String desc, String imagePath, List<AudioItem> audios}) async {
    if (name != null || desc != null || imagePath != null) {
      // if(await futureAuth()){
      await DBProvider.db
          .collectionEdit(id, name: name, desc: desc, picture: imagePath);
      if (audios.isNotEmpty) {
        // log(audios.length.toString(), name: "Playlist.Edit");
        // audios.forEach((element) async {
        //   await DBProvider.db.collectionAddAudio(id, element.id);
        // });
        List<int> ids = [];
        audios.forEach((element) {
          ids.add(element.id);
        });
        await DBProvider.db.collectionAddAudio(id, ids);
      }
      // }else {
      //   await DBProvider.db.collectionEdit(id, name: name, desc:desc ,picture: imagePath);
      //   CollectionItem item = await DBProvider.db.collectionGet(id);
      //   String urlQuery = urlConstructor(Methods.playlist.edit);
      //   String token = await tokenDB();
      //   Map<String, dynamic> body = Map();
      //   body['id'] = item.idS;
      //   if (imagePath != null) body['picture'] =
      //   await MultipartFile.fromFile(imagePath, filename: imagePath
      //       .split("/")
      //       .last);
      //   if (name != null) body['name'] = name;
      //   if (desc != null) body['description'] = desc;
      //   var dio = Dio();
      //   dio.options.headers['Authorization'] = 'Bearer $token';
      //   var formData = FormData.fromMap(body);
      //   Response response = await dio.post(urlQuery, data: formData,);
      //   if (response.statusCode == 200) {
      //     return Put(error: 200, mess: "Ok", localError: false);
      //   } else {
      //     return Put(error: response.statusCode, mess: "", localError: true);
      //   }
      // }
    }
  }

  static Future removeAudio(int idAudio, int idCollection) async {
    await DBProvider.db.collectionDeleteAudio(idCollection, idAudio);
  }

  static Future<Put> deleteS(int idsPlaylist) async {
    String token = await tokenDB();
    String urlQuery =
        urlConstructor(Methods.playlist.deletePlaylist(idsPlaylist));
    Map<String, dynamic> body = Map();
    var response;
    response = await Rest.post(urlQuery, body, token: token);
    if (response is Put) {
      return response;
    } else {
      return Put(code: 401, message: "ok", isLocal: false);
    }
  }

  static Future<Put> deleteLocal(int idPlaylist) async {
    await DBProvider.db.collectionDelete(idPlaylist);
    return Put(code: 401, message: "ok", isLocal: false);
  }

  static Future<int> createOnlyS(String name, String desc, String file) async {
    print("create playlist == = == = == = ==");
    String token = await tokenDB();
    String urlQuery = urlConstructor(Methods.playlist.create);
    Map<String, dynamic> body = Map();
    body['name'] = name;
    body['description'] = desc;
    if (file == null || file == "") {}

    print(urlQuery);
    var dio = Dio();
    var formData = FormData.fromMap({
      "name": name,
      "description": desc,
      // "Authorization":"Bearer $token",
      "Accept": "application/json",
      "Content-Type": "multipart/form-data;",
      "picture": file == null
          ? MultipartFile.fromBytes(
              (await rootBundle.load('assets/images/play.png'))
                  .buffer
                  .asUint8List(),
              filename: "play.png")
          : await MultipartFile.fromFile(file, filename: file.split("/").last),
    });

    dio.options.headers['Authorization'] = 'Bearer $token';

    Response response = await dio.post(
      urlQuery,
      data: formData,
    );
    if (response.statusCode == 201) {
      print("create only S Collection" + response.statusCode.toString());
      return response.data['id'];
      //return Put(error: 200, mess: "Ok", localError: false);
    } else {
      return null;
      //return Put(error: response.statusCode, mess: "", localError: true);
    }
  }

  static Future<List<CollectionItem>> syncCollections() async {
    if (await futureAuth()) {
      return await DBProvider.db.getCollections();
    } else if (!await checkConnection()) {
      return await DBProvider.db.getCollections();
    } else {
      List<CollectionItem> L = await DBProvider.db.getCollections();
      List<CollectionItem> S;
      String token = await tokenDB();
      String urlQuery = urlConstructor(Methods.playlist.get);
      Map<String, dynamic> body = Map();
      var response;
      response = await Rest.post(urlQuery, body, token: token);
      if (response is Put) {
        if (response.code == 401) {
          tokenDB(token: "null");
          return null;
        }
        return [];
      } else {
        S = response
            .map((i) => CollectionItem.fromMap(i))
            .toList()
            .cast<CollectionItem>();
      }

      for (int i = 0; i < S.length; i++) {
        bool find = false;
        for (int j = 0; j < L.length; j++) {
          if (L[j].idS != null && S[i].idS == L[j].idS) {
            find = true;
            print("${L[j].updateAt} before ${S[i].updateAt}");
            if (L[j].updateAt.isBefore(S[i].updateAt)) {
              List<AudioItem> step = (await get(id: L[j].idS, ids: L[j].idS));
              await DBProvider.db.collectionEdit(L[j].id,
                  name: S[i].name,
                  desc: S[i].description,
                  picture: S[i].picture,
                  isLocalPicture: false,
                  uploadPicture: true,
                  ids: S[i].idS);
              S[i].playlist = step;

              for (int i1 = 0; i1 < S[i].playlist.length; i1++) {
                bool find1 = false;
                for (int j1 = 0; j1 < L[j].playlist.length; j1++) {
                  if (S[i].playlist[i1].idS != null &&
                      S[i].playlist[i1].idS == L[j].playlist[j1].idS) {
                    find1 = true;
                  }
                  if (!find1) {
                    AudioItem itemAudio = await DBProvider.db
                        .getAudio(0, idS: S[i].playlist[i1].idS);
                    DBProvider.db.collectionAddAudio(L[j].id, [itemAudio.id]);
                  }
                }
              }
              for (int i1 = 0; i1 < L[j].playlist.length; i1++) {
                bool find1 = false;
                for (int j1 = 0; j1 < S[i].playlist.length; j1++) {
                  if (L[j].playlist[i1].idS != null &&
                      S[i].playlist[j1].idS == L[j].playlist[i1].idS) {
                    find1 = true;
                  }
                }
                if (!find1 || L[j].playlist[i1].idS == null) {
                  await addAudioOnlyS(S[i].idS, L[j].playlist[i].idS);
                }
              }
            } else {
              await editOnlyS(L[j].id,
                  name: L[j].name,
                  desc: L[j].description,
                  imagePath: L[j].isLocalPicture && !L[j].uploadPicture
                      ? L[j].picture
                      : null);
              //todo change on S
              await DBProvider.db.collectionEdit(L[j].id, uploadPicture: true);
              // L = await DBProvider.db.collectionsGet();

              List<AudioItem> step = (await get(id: L[j].id, ids: L[j].idS));
              S[i].playlist = step;

              for (int i1 = 0; i1 < S[i].playlist.length; i1++) {
                bool find1 = false;
                for (int j1 = 0; j1 < L[j].playlist.length; j1++) {
                  if (S[i].playlist[i1].idS != null &&
                      S[i].playlist[i1].idS == L[j].playlist[j1].idS) {
                    find1 = true;
                  }
                  if (!find1) {
                    try {
                      AudioItem itemAudio = await DBProvider.db
                          .getAudio(0, idS: S[i].playlist[i1].idS);
                      // print(itemAudio.toMap());
                      DBProvider.db.collectionAddAudio(L[j].id, [itemAudio.id]);
                    } catch (e) {
                      print(e);
                    }
                  }
                }
              }
              for (int i1 = 0; i1 < L[j].playlist.length; i1++) {
                bool find1 = false;
                for (int j1 = 0; j1 < S[i].playlist.length; j1++) {
                  if (L[j].playlist[i1].idS != null &&
                      S[i].playlist[j1].idS == L[j].playlist[i1].idS) {
                    find1 = true;
                  }
                }
                if (!find1 || L[j].playlist[i1].idS == null) {
                  await addAudioOnlyS(S[i].idS, L[j].playlist[i].idS);
                }
              }
            }
          }
        }
        if (!find) {
          S[i].playlist = await get(id: S[i].id, ids: S[i].idS);
          await DBProvider.db.collectionAdd(S[i]);
        }
      }
      for (int i = 0; i < L.length; i++) {
        bool find = false;
        for (int j = 0; j < S.length; j++) {
          if (L[j].idS != null && S[j].idS == L[j].idS) {
            find = true;
          }
        }
        if (!find) {
          int ids =
              await createOnlyS(L[i].name, L[i].description, L[i].picture);
          await DBProvider.db.collectionEdit(L[i].id, ids: ids);
        }
      }
      return DBProvider.db.getCollections();
    }
  }

  static Future<Put> addAudioOnlyS(int idPlaylist, int idS) async {
    String token = await tokenDB();
    String urlQuery = urlConstructor(Methods.playlist.addTo);
    Map<String, dynamic> body = Map();
    body['id'] = idPlaylist;
    var response;
    body['audio'] = idS.toString();
    response = await Rest.post(urlQuery, body, token: token);
    print(response.runtimeType);
    if (response.runtimeType.toString() == "Put") {
      Put r = response;
      if (r.code == 401) {
        tokenDB(token: "null");
        return null;
      }
    } else {
      return Put(code: 200, message: "ok", isLocal: false);
    }
  }

  static Future<Put> editOnlyS(int id,
      {String name, String desc, String imagePath}) async {
    if (name != null || desc != null || imagePath != null) {
      CollectionItem item = await DBProvider.db.collectionGet(id);
      String urlQuery = urlConstructor(Methods.playlist.edit);
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
      if (response.statusCode == 200) {
        return Put(code: 200, message: "Ok", isLocal: false);
      } else {
        return Put(code: response.statusCode, message: "", isLocal: true);
      }
    }
  }

  ///================================================================================
  static Future<List<CollectionItem>> getAll() async {
    if (!await checkConnection() || await futureAuth()) {
      return await DBProvider.db.getCollections();
    } else {
      List<CollectionItem> out = [];
      List<CollectionItem> l = await DBProvider.db.getCollections();
      List<CollectionItem> s = [];
      String token = await tokenDB();
      String urlQuery = urlConstructor(Methods.playlist.get);
      Map<String, dynamic> body = Map();
      var response;
      response = await Rest.post(urlQuery, body, token: token);
      if (response is Put) {
        if (response.code == 401) {
          tokenDB(token: "null");
          return null;
        }
        return l;
      } else {
        s = response
            .map((i) => CollectionItem.fromMap(i))
            .toList()
            .cast<CollectionItem>();
      }
      out = l;
      for (int i = 0; i < s.length; i++) {
        bool find = false;
        for (int j = 0; j < out.length; j++) {
          if (out[j].idS != null) {
            if (out[j].idS == s[i].idS) {
              find = true;
            }
          }
        }
        if (!find) {
          out.add(s[i]);
        }
      }
      return out;
    }
  }

  static Future<List<AudioItem>> getAudioFromId({int id, int idS}) async {
    if (id != null) {
      // return await DBProvider.db.collectionGet(id);
      return [];
    } else if (idS != null) {
      String token = await tokenDB();
      String urlQuery =
          urlConstructor(Methods.playlist.getAudioFromPlaylist(idS));
      Map<String, dynamic> body = Map();
      body['id'] = idS ?? (await DBProvider.db.collectionGet(id)).idS;
      var response;
      response = await Rest.post(urlQuery, body, token: token);
      print(response.runtimeType);
      if (response.runtimeType.toString() == "Put") {
        Put r = response;
        if (r.code == 401) {
          tokenDB(token: "null");
          return [];
        }
        return [];
      }
      return response['audios']
          .map((i) => AudioItem.fromMap(i))
          .toList()
          .cast<AudioItem>();
    }
  }

  static Future<int> create(String name, String desc, String file) async {
    print("create playlist === === === ===");

    int dbId = await DBProvider.db.collectionAdd(
      CollectionItem(
          picture: file,
          name: name,
          count: 0,
          duration: Duration(milliseconds: 0),
          isLocalPicture: true,
          uploadPicture: false,
          description: desc),
    );
    if (await checkConnection() && !await futureAuth()) {
      int res = await createOnlyS(name, desc, file);
      DBProvider.db.collectionEdit(dbId, ids: res);
    }
    return dbId;
  }
}
