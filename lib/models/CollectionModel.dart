import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:recorder/DB/DBModel.dart';
import 'package:recorder/models/AudioModel.dart';

class CollectionItem {
  final int id;
  String picture;
  final String name;
  final String description;
  List<AudioItem> playlist;
  final String publicationDate;
  int count;
  Duration duration;
  int idS;
  bool isLocalPicture;
  bool uploadPicture;
  DateTime createAt;
  DateTime updateAt;

  CollectionItem(

      {@required this.picture,
      @required this.name,
      this.description,
      this.playlist,
      this.publicationDate,
      @required this.count,
      @required this.duration,
        this.idS,
        this.id,
        this.isLocalPicture,
        this.updateAt,this.createAt,
        this.uploadPicture,
      });

  factory CollectionItem.fromMap(Map<String, dynamic> map) {
    return new CollectionItem(
      idS: map['id'] as int,
      picture: map['picture'] as String,
      name: map['name'] == null?"":map['name'].toString(),
      description: map['description'] as String,
      playlist: null,
      publicationDate: map['publicationDate'] as String,
      count: map['count'] as int,
      duration: Duration(milliseconds: 0),
      uploadPicture: true,
      isLocalPicture: false,
      updateAt: map['updated_at']==null?null: DateFormat("yyyy-MM-ddTHH:mm:ss").parse(map['updated_at']),
      createAt: map['created_at']==null?null: DateFormat("yyyy-MM-ddTHH:mm:ss").parse(map['created_at']),
      //map['timeOfCollection'],
    );
  }

  factory CollectionItem.fromDB(Map<String, dynamic> map) {
    print("DB UPDATE ${map[TableCollection.updateAt]} ");
    return new CollectionItem(
        idS: map[TableCollection.idS] as int,
        id: map[TableCollection.id] as int,
        picture: map[TableCollection.picture] as String,
        name: map[TableCollection.name] == null?"":map[TableCollection.name].toString(),
        description: map[TableCollection.desc] as String,
        playlist: [],
        publicationDate: "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().day}",
        count: 0,
        duration: Duration(milliseconds: int.parse(map[TableCollection.duration])), //map['timeOfCollection'],
      isLocalPicture: map[TableCollection.isLocalPicture] ==1?true:false,
      uploadPicture: map[TableCollection.uploadPicture] ==1?true:false,
      updateAt: map[TableCollection.updateAt] == null? null:  DateFormat("yyyy-MM-dd HH:mm:ss").parse(map[TableCollection.updateAt])
    );
  }

  Map<String, dynamic> toMap() {
    return {
      TableCollection.id: this.id,
      TableCollection.picture: this.picture,
      TableCollection.name: this.name,
      TableCollection.desc: this.description,
      TableCollection.audios: json.encode(this.playlist == null? []:this.playlist.map((e){if(e == null){return null;}else return e.id;}).toList().cast<int>()),
      TableCollection.duration: this.duration.inMilliseconds.toString(),
      TableCollection.uploadPicture: this.uploadPicture?1:0,
      TableCollection.isLocalPicture:  this.isLocalPicture?1:0,
      TableCollection.idS: this.idS,
      TableCollection.updateAt: this.updateAt.toString()
    } ;
  }

  @override
  String toString() {
    return toMap().toString();
  }

}
