class TableUser{
  static get table => "user";
  static get name => "name";
  static get picture => "picture";
  static get subscription => "subscription";
  static get free => "free";
  static get max => "max";
  static get local => "localProfile";
}

class TableAudio{
  static get table => "audio";
  static get id => "id";
  static get idS => "idS";
  static get name => "name";
  static get picture => "picture";
  static get uploadPicture => "uploadPicture";
  static get isLocalPicture => "isLocalPicture";
  static get desc => "desc";
  static get duration => "duration";
  static get pathAudio => "pathAudio";
  static get isLocalAudio => "isLocalAudio";
  static get uploadAudio => "uploadAudio";
  static get createAt => "createAt";
  static get updateAt => "updateAt";
  static get deleted => "deleted";
}

class TableCollection{
  static get table => "collections";//
  static get id => "id";
  static get idS => "idS";//??
  static get name => "name";//
  static get picture => "picture";//
  static get uploadPicture => "uploadPicture";//
  static get isLocalPicture => "isLocalPicture";//
  static get desc => "desc";//
  static get duration => "duration";//
  static get createAt => "createAt";//
  static get updateAt => "updateAt";//
  static get audios => "audios";
}

