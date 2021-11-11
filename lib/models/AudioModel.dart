import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:recorder/DB/DBModel.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';

class Select{
  bool select;
}

class AudioItem extends Select {
  String name;
  Duration duration;
  int activeIcon = IconsSvg.pause;
  int inActiveIcon = IconsSvg.play;
  String description;
  String pathAudio;
  String picture;
  int id;
  int idS;
  bool isLocalPicture;
  bool uploadPicture;
  bool isLocalAudio;
  bool uploadAudio;
  DateTime createAt;
  DateTime updateAt;
  bool deleted;

  AudioItem({
    @required this.name,
    this.duration ,
    this.activeIcon ,
    this.inActiveIcon ,
    @required this.description,
    @required this.pathAudio,
    @required this.picture,
    this.id,
    this.updateAt,
    this.uploadAudio,
    this.isLocalAudio,
    this.createAt,
    this.uploadPicture,
    this.isLocalPicture,
    this.idS,
    this.deleted = false,
  });

  factory AudioItem.fromMap(Map<String, dynamic> map) {
    return new AudioItem(
      name: map['name']==null?"":map['name'].toString(),
      description: map['description'] as String,
      pathAudio: map['url'] as String,
      picture: map['picture'] as String,
      idS: map['id'] as int,
      duration:  Duration(milliseconds: map['duration']??0),
      activeIcon: IconsSvg.pause,
      inActiveIcon: IconsSvg.play,
      updateAt: map['updated_at']==null?null: DateFormat("yyyy-MM-ddTHH:mm:ss").parse(map['updated_at']),
      createAt: map['created_at']==null?null: DateFormat("yyyy-MM-ddTHH:mm:ss").parse(map['created_at']),
      uploadPicture: true,
      isLocalPicture: false,
      isLocalAudio: false,
      uploadAudio: true,
      deleted: map['deleted'] == 1,
    );
  }

  factory AudioItem.fromDB(Map<String, dynamic> map) {
    return new AudioItem(
      name: map[TableAudio.name] == null?"":map[TableAudio.name].toString(),
      description: map[TableAudio.desc] as String,
      pathAudio: map[TableAudio.pathAudio] as String,
      picture: map[TableAudio.picture] as String,
      id: map[TableAudio.id] as int,
      duration:  Duration(milliseconds: int.parse(map[TableAudio.duration])),
      activeIcon: IconsSvg.pause,
      inActiveIcon: IconsSvg.play,
      isLocalAudio: map[TableAudio.isLocalAudio] == 0?false:true,
      uploadAudio: map[TableAudio.uploadAudio] == 0?false:true,
      uploadPicture: map[TableAudio.uploadPicture] == 0?false:true,
      isLocalPicture: map[TableAudio.isLocalPicture] == 0?false:true,
      idS: map[TableAudio.idS],
      createAt: DateFormat("yyyy-MM-dd HH:mm:ss").parse(map[TableAudio.createAt]),
      updateAt: DateFormat("yyyy-MM-dd HH:mm:ss").parse(map[TableAudio.updateAt]),
      deleted: map[TableAudio.deleted] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      TableAudio.name: this.name,
      TableAudio.desc: this.description,
      TableAudio.pathAudio: this.pathAudio,
      TableAudio.picture: this.picture,
      TableAudio.id: this.id,
      TableAudio.duration: this.duration.inMilliseconds,
      TableAudio.idS: this.idS,
      TableAudio.uploadPicture: this.uploadPicture == null?0:this.uploadPicture?1:0,
      TableAudio.uploadAudio: this.uploadAudio == null?0:this.uploadAudio?1:0,
      TableAudio.isLocalPicture: this.isLocalPicture == null?1:this.isLocalPicture?1:0,
      TableAudio.isLocalAudio:  this.isLocalAudio == null?1:this.isLocalAudio?1:0,
      TableAudio.createAt: this.createAt.toString(),
      TableAudio.updateAt:this.updateAt.toString(),
      TableAudio.deleted: this.deleted ? 1 : 0,
    };
  }
}
