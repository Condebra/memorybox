import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:recorder/DB/DBModel.dart';
import 'package:recorder/Utils/tokenDB.dart';
import 'package:recorder/models/AudioItem.dart';
import 'package:recorder/models/CollectionModel.dart';
import 'package:recorder/models/ProfileModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB();
    print("db=============>${_database.toString()}<===========");
    return _database;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "base26.db");
    // print("=======================path================================\n$path");
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE ${TableUser.table} ( '
      '${TableUser.name} TEXT, '
      '${TableUser.free} TEXT, '
      '${TableUser.max} TEXT, '
      '${TableUser.picture} TEXT'
      ')',
    );
    await db.execute(
      'CREATE TABLE ${TableAudio.table} ('
      '${TableAudio.id} INTEGER PRIMARY KEY AUTOINCREMENT,'
      '${TableAudio.name} TEXT, '
      '${TableAudio.desc} TEXT, '
      '${TableAudio.duration} TEXT,'
      '${TableAudio.createAt} TEXT,'
      '${TableAudio.updateAt} TEXT,'
      '${TableAudio.pathAudio} TEXT, '
      '${TableAudio.picture} TEXT,'
      '${TableAudio.isLocalPicture} INTEGER,'
      '${TableAudio.uploadPicture} INTEGER,'
      '${TableAudio.uploadAudio} INTEGER,'
      '${TableAudio.isLocalAudio} INTEGER,'
      '${TableAudio.idS} INTEGER, '
      '${TableAudio.deleted} INTEGER'
      ')',
    );
    await db.execute(
      'CREATE TABLE ${TableCollection.table} ('
      '${TableCollection.id} INTEGER PRIMARY KEY AUTOINCREMENT,'
      '${TableCollection.name} TEXT, '
      '${TableCollection.desc} TEXT, '
      '${TableCollection.duration} TEXT, '
      '${TableCollection.audios} TEXT, '
      '${TableCollection.picture} TEXT, '
      '${TableCollection.isLocalPicture} INTEGER,'
      '${TableCollection.uploadPicture} INTEGER,'
      '${TableCollection.idS} INTEGER'
      '${TableCollection.createAt} TEXT,'
      '${TableCollection.updateAt} TEXT'
      ')',
    );
  }

  Future<bool> deleteDataFromDB() async {
    final db = await this.database;
    try {
      await db.delete(TableUser.table);
      await db.delete(TableAudio.table);
      await db.delete(TableCollection.table);
      print("db delete success");
      return Future.value(true);
    } catch (e) {
      print('db delete error $e');
      return Future.value(false);
    }
  }


  Future<ProfileModel> profileGet() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString(TableUser.name);
    String picture = prefs.getString(TableUser.picture);
    bool local = !await uploadProfilePhoto();
    print('$name $picture');
    return ProfileModel(
        picture: picture,
        name: name,
        phone: null,
        free: 500,
        max: 500,
        createdAt: null,
        subscribe: null,
        updatedAt: null,
        id: null,
        local: local,

    );
  }

  Future<void> profileEdit({String name, String picture, bool isLocal}) async {
    final prefs = await SharedPreferences.getInstance();
    if (name != null) prefs.setString(TableUser.name, name);
    if (picture != null) {
      prefs.setString(TableUser.picture, picture);
      if (isLocal != null) {
        prefs.setBool(TableUser.local, isLocal);
      }
      await uploadProfilePhoto(state: false);
    }
  }

  Future<List<AudioItem>> getAudios({bool removed = false}) async {
    Database db = await this.database;
    int deleted = removed ? 1 : 0;
    final List<Map<String, dynamic>> list = await db.query(TableAudio.table,
        where: "${TableAudio.deleted} = ?",
        whereArgs: [deleted],
        orderBy: "${TableAudio.id} DESC");
    // print("=== AudiosGet "+list.toString());
    List<AudioItem> listAudio = [];
    list.forEach((element) {
      listAudio.add(AudioItem.fromDB(element));
    });
    return listAudio;
  }

  Future<AudioItem> getAudio(int id, {int idS}) async {
    Database db = await this.database;
    final List<Map<String, dynamic>> list = await db.query(TableAudio.table,
        where: "${idS == null ? TableAudio.id : TableAudio.idS} = ?",
        whereArgs: [idS ?? id]);
    // print("=== AudioGet $idS" + list.toString());

    return AudioItem.fromDB(list.first);
  }

  Future<int> getIdByName(String name) async {
    Database db = await this.database;
    final id = await db.query(TableAudio.table,
        where: "${TableAudio.name} = ?", whereArgs: [name]);
    // print("=======>getId==> ${id[0].values.first}");
    return id[0].values.first;
  }

  Future<CollectionItem> collectionGet(int id) async {
    Database db = await this.database;
    final List<Map<String, dynamic>> list = await db.query(
      TableCollection.table,
      where: "${TableCollection.id} = ?",
      whereArgs: [id],
    );
    print("collectionGet " + list.toString());

    CollectionItem item = CollectionItem.fromDB(list[0]);
    List<AudioItem> audios = [];
    List<int> audiosIds =
        json.decode(list[0][TableCollection.audios]).cast<int>();
    for (int i = 0; i < audiosIds.length; i++) {
      AudioItem step = await getAudio(audiosIds[i]);
      if (step != null) audios.add(step);
      //print("id audio "+step.id.toString());
    }

    // audiosIds.forEach((element) async { audios.add(await audioGet(element)); });

    item.playlist = audios;
    print(" === Collection ${item.playlist.length}");
    item.count = audios.length;
    int time = 0;
    for (int i = 0; i < audios.length; i++) {
      time += audios[i].duration.inMilliseconds;
    }
    item.duration = Duration(milliseconds: time);
    return item;
  }

  Future<void> deleteAudio(int id) async {
    Database db = await this.database;
    await db.delete(TableAudio.table,
        where: "${TableAudio.id} = ?", whereArgs: [id]);
  }

  Future<void> removeAudio(int id) async {
    Database db = await this.database;
    int deleted = 1;
    await db.update(TableAudio.table, {TableAudio.deleted: deleted},
        where: "${TableAudio.id} = ?", whereArgs: [id]);
  }

  Future<void> restoreAudio(int id) async {
    Database db = await this.database;
    int deleted = 0;
    await db.update(TableAudio.table, {TableAudio.deleted: deleted},
        where: "${TableAudio.id} = ?", whereArgs: [id]);
  }

  Future<void> audioEdit(
    int id, {
    String name,
    String picture,
    String desc,
    int ids,
    bool uploadAudio,
    bool isLocalPicture,
    bool uploadPicture,
    String pathAudio,
    bool isLocalAudio,
  }) async {
    Database db = await this.database;
    if (name != null) {
      await db.update(TableAudio.table, {TableAudio.name: name},
          where: "${TableAudio.id} = ?", whereArgs: [id]);
    }
    if (picture != null) {
      await db.update(TableAudio.table, {TableAudio.picture: picture},
          where: "${TableAudio.id} = ?", whereArgs: [id]);
    }
    if (desc != null) {
      await db.update(TableAudio.table, {TableAudio.desc: desc},
          where: "${TableAudio.id} = ?", whereArgs: [id]);
    }
    if (pathAudio != null) {
      await db.update(TableAudio.table, {TableAudio.pathAudio: pathAudio},
          where: "${TableAudio.id} = ?", whereArgs: [id]);
    }
    if (ids != null) {
      await db.update(TableAudio.table, {TableAudio.idS: ids},
          where: "${TableAudio.id} = ?", whereArgs: [id]);
    }
    if (uploadAudio != null) {
      await db.update(
          TableAudio.table, {TableAudio.uploadAudio: uploadAudio ? 1 : 0},
          where: "${TableAudio.id} = ?", whereArgs: [id]);
    }
    if (isLocalPicture != null) {
      await db.update(
          TableAudio.table, {TableAudio.isLocalPicture: isLocalPicture ? 1 : 0},
          where: "${TableAudio.id} = ?", whereArgs: [id]);
    }
    if (uploadPicture != null) {
      await db.update(
          TableAudio.table, {TableAudio.uploadPicture: uploadPicture ? 1 : 0},
          where: "${TableAudio.id} = ?", whereArgs: [id]);
    }
    if (isLocalAudio != null) {
      await db.update(
          TableAudio.table, {TableAudio.isLocalAudio: isLocalAudio ? 1 : 0},
          where: "${TableAudio.id} = ?", whereArgs: [id]);
    }
    await db.update(
        TableAudio.table, {TableAudio.updateAt: DateTime.now().toString()},
        where: "${TableAudio.id} = ?", whereArgs: [id]);
  }

  Future<int> audioAdd(AudioItem item) async {
    Database db = await this.database;
    item.createAt = DateTime.now();
    item.updateAt = DateTime.now();
    item.pathAudio = item.pathAudio.replaceAll(".temp", "");

    return (await db.insert(TableAudio.table, item.toMap()));
  }

  Future<List<CollectionItem>> getCollections() async {
    Database db = await this.database;
    final List<Map<String, dynamic>> list =
        await db.query(TableCollection.table,
          orderBy: "${TableCollection.id} DESC",
        );
    // print("=== collectionsGet ${list}");
    List<CollectionItem> items = [];
    list.forEach((element) async {
      CollectionItem item = CollectionItem.fromDB(element);
      List<AudioItem> audios = [];
      List<int> audiosIds =
          (json.decode(element[TableCollection.audios])).cast<int>();
      for (int i = 0; i < audiosIds.length; i++) {
        AudioItem a = await getAudio(audiosIds[i]);
        if (a != null) audios.add(a);
      }
      item.playlist = audios;
      item.count = audios.length;
      int time = 0;
      for (int i = 0; i < audios.length; i++) {
        time += audios[i].duration.inMilliseconds;
      }
      item.duration = Duration(milliseconds: time);
      items.add(item);
    });
    // print("Db ${items.length} collections");
    return items;
  }

  Future<int> collectionAdd(CollectionItem item) async {
    Database db = await this.database;
    item.createAt = DateTime.now();
    item.updateAt = DateTime.now();
    return await db.insert(TableCollection.table, item.toMap());
  }

  Future<void> collectionEdit(int id,
      {String name,
      String picture,
      String desc,
      int ids,
      bool isLocalPicture,
      bool uploadPicture}) async {
    Database db = await this.database;
    if (name != null) {
      await db.update(TableCollection.table, {TableCollection.name: name},
          where: "${TableCollection.id} = ?", whereArgs: [id]);
    }
    if (picture != null) {
      await db.update(TableCollection.table, {TableCollection.picture: picture},
          where: "${TableCollection.id} = ?", whereArgs: [id]);
    }
    if (desc != null) {
      await db.update(TableCollection.table, {TableCollection.desc: desc},
          where: "${TableCollection.id} = ?", whereArgs: [id]);
    }
    if (ids != null) {
      await db.update(TableCollection.table, {TableCollection.idS: ids},
          where: "${TableCollection.id} = ?", whereArgs: [id]);
    }
    if (isLocalPicture != null) {
      await db.update(TableCollection.table,
          {TableCollection.isLocalPicture: isLocalPicture},
          where: "${TableCollection.id} = ?", whereArgs: [id]);
    }
    if (uploadPicture != null) {
      await db.update(
          TableCollection.table, {TableCollection.uploadPicture: uploadPicture},
          where: "${TableCollection.id} = ?", whereArgs: [id]);
    }
    await db.update(TableCollection.table,
        {TableCollection.updateAt: DateTime.now().toString()},
        where: "${TableAudio.id} = ?", whereArgs: [id]);
  }

  Future<void> collectionDelete(int id) async {
    Database db = await this.database;
    await db.delete(TableCollection.table,
        where: "${TableCollection.id} = ?", whereArgs: [id]);
  }

  Future<void> collectionAddAudio(int id, List<int> audioIds) async {
    Database db = await this.database;
    CollectionItem item = await collectionGet(id);
    bool find = false;
    // for (int i = 0; i < item.playlist.length; i++) {
    //   if (item.playlist[i].id == audioId) find = true;
    // }
    if (!find) {
      List<int> list = [];
      // for (int i = 0; i < item.playlist.length; i++) {
      //   list.add(item.playlist[i].id);
      // }
      list.addAll(audioIds);
      log("${list.toList()}", name: "add $list");
      await db.update(
          TableCollection.table, {TableCollection.audios: json.encode(list)},
          where: "${TableCollection.id} = ?", whereArgs: [id]);
    }
  }

  Future<void> collectionDeleteAudio(int id, int audioId) async {
    Database db = await this.database;
    CollectionItem item = await collectionGet(id);
    for (int i = 0; i < item.playlist.length; i++) {
      if (item.playlist[i].id == audioId) item.playlist.removeAt(i);
    }
    List<int> list = [];
    for (int i = 0; i < item.playlist.length; i++) {
      list.add(item.playlist[i].id);
    }
    await db.update(
        TableCollection.table, {TableCollection.audios: json.encode(list)},
        where: "${TableCollection.id} = ?", whereArgs: [id]);
  }
}
