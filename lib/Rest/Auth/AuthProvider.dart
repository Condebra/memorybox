import 'package:recorder/models/Put.dart';
import 'package:recorder/Rest/API.dart';
import 'package:recorder/Rest/Rest.dart';
import 'package:recorder/Utils/tokenDB.dart';

class AuthProvider{
  static Future<Put> sendCode(String phone)async{
    String urlQuery = urlConstructor(Methods.auth.sendCode);
    Map <String,dynamic> body = Map();
    body['phone'] = phone;
    
    var response;
    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      return response;
    }else{
      return Put(error: 200, mess: "ok", localError: false);
    }
  }
  static Future<Put> checkCode(String phone, String code)async{
    String urlQuery = urlConstructor(Methods.auth.checkCode);
    Map <String,dynamic> body = Map();
    body['phone'] = phone;
    body['code'] = code;
    var response;
    response =await  Rest.post(urlQuery, body);
    if(response is Put) {
      return response;
    }else{
      await tokenDB(token: response['token']);
      return Put(error: 200, mess: "ok", localError: false);
    }
  }
}