part of 'API.dart';

class Methods {
  static _AuthMethods get auth => _AuthMethods();
  static _AudioMethods get audio => _AudioMethods();
  static _PlaylistMethods get playlist => _PlaylistMethods();
  static _UserMethods get user => _UserMethods();
}

class _AuthMethods{
  String get sendCode => "send";
  String get checkCode => "auth";
}
class _AudioMethods{
  String get  upload => "upload";
  String get  get => "audio";
  String get  getUserAudio => "audios";
  String get  delete => "audio/delete";
  String get  deleted => "audios/deleted";
  String get  restore => "audio/restore";
  String get  edit => "audio/change";
}

class _PlaylistMethods{
  String get  get => "playlists";
  String get  create => "playlist/create";
  String get  edit => "playlist/change";
  String getAudioFromPlaylist(int idPlaylist) => "playlist/$idPlaylist";
  String get  deleteAudio => "playlist/delete";
  String get addTo => "playlist/add";
  String deletePlaylist(int idPlaylist) => "playlist/$idPlaylist/delete";
}

class _UserMethods{
  String get  get => "user";
  String get  edit => "change";

}






