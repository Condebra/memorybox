import 'package:dio/dio.dart';
import 'package:recorder/DB/DB.dart';
import 'package:recorder/Rest/API.dart';
import 'package:recorder/Rest/Rest.dart';
import 'package:recorder/Utils/checkConnection.dart';
import 'package:recorder/Utils/tokenDB.dart';
import 'package:recorder/models/ProfileModel.dart';
import 'package:recorder/models/Put.dart';

class UserProvider{

  static Future<dynamic> get()async{
    ProfileModel profile = await DBProvider.db.profileGet();
    if(await futureAuth() || !await checkConnection()){
      return profile;
    }else {
      String urlQuery = urlConstructor(Methods.user.get);
      String token = await tokenDB();
      Map<String, dynamic> body = Map();
      var response;
      response = await Rest.post(urlQuery, body, token: token);
      if (response is Put) {
        return response;
      } else {
        ProfileModel profileS =  ProfileModel.fromMap(response);
        if(profileS.name != profile.name){
          await edit(name: profile.name);
        }
        if(!(await uploadProfilePhoto())){
          await edit(imagePath: profile.picture);
        }
        return profileS;
      }
    }
  }

  static Future<Put> edit({String name, String phone, String imagePath}) async {
    if (name != null || phone != null || imagePath != null) {
      await DBProvider.db.profileEdit(name: name, picture: imagePath);
      if (await futureAuth()) {
        return Put(error: 200, localError: true, mess: "ok");
      } else {
        String urlQuery = urlConstructor(Methods.user.edit);
        String token = await tokenDB();
        Map<String, dynamic> body = Map();
        if (imagePath != null) {
          body['picture'] =
          await MultipartFile.fromFile(imagePath, filename: imagePath
              .split("/")
              .last);
        }
        if (name != null) body['name'] = name;
        if (phone != null) body['description'] = phone;
        var dio = Dio();
        dio.options.headers['Authorization'] = 'Bearer $token';
        var formData = FormData.fromMap(body);
        Response response = await dio.post(urlQuery, data: formData,);
        if (response.statusCode == 200) {
          if (imagePath != null) {
            await uploadProfilePhoto(state: true);
          }
          return Put(error: 200, mess: "Ok", localError: false);
        } else {
          return Put(error: response.statusCode, mess: "", localError: true);
        }
      }
    }
  }

}