part 'Methods.dart';
part 'Server.dart';
part 'UrlConstructor.dart';

class Api {
  static final bool _test = false;
  static String get api => _getApi();
  static String _getApi(){
    if(_test){
      return "apitest";
    }else{
      return "api";
    }
  }
}