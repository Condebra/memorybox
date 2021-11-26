import 'package:intl/intl.dart';

class ProfileModel {
  final String picture;
  final String name;
  final String phone;
  final int subscribe;
  final DateTime created_at;
  final DateTime updated_at;
  final int id;
  final int free;
  final int max;
  final bool local;

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return new ProfileModel(
      picture: map['picture'] as String,
      name: map['name'],
      phone: map['phone'] as String,
      subscribe: map['subscribe'] as int,
      created_at: DateFormat("yyyy-MM-ddTHH:mm:ss.vvvZ").parse(map['created_at']),
      updated_at: DateFormat("yyyy-MM-ddTHH:mm:ss.vvvZ").parse(map['updated_at']),
      free: map['space']['free'].toInt() as int,
      max: map['space']['max'].toInt() as int,
      id: map['id'],
      local: false
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'picture': this.picture,
      'name': this.name,
      'phone': this.phone,
      'subscribe': this.subscribe,
      'created_at': this.created_at,
      'updated_at': this.updated_at,
      'avMemory': this.free,
      'usMemory': this.max,
    } as Map<String, dynamic>;
  }

  ProfileModel(
      {this.picture, this.name, this.phone, this.free, this.max, this.created_at, this.subscribe,this.updated_at, this.id, this.local});
}
