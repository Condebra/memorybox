part of 'API.dart';

String urlConstructor(String method){
  return Server.relevant+"/"+Api.api+"/"+method;
}