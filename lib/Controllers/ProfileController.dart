import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:recorder/Controllers/States/ProfileState.dart';
import 'package:recorder/Rest/User/UserProvider.dart';
import 'package:recorder/Routes.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/Utils/DialogsIntegron/DialogIntegron.dart';
import 'package:recorder/Utils/DialogsIntegron/DialogLoading.dart';
import 'package:recorder/Utils/DialogsIntegron/DialogRecorder.dart';
import 'package:recorder/Utils/app_keys.dart';
import 'package:recorder/Utils/tokenDB.dart';
import 'package:recorder/models/ProfileModel.dart';
import 'package:rxdart/rxdart.dart';

class ProfileController{

  final _picker = ImagePicker();

  bool _edit = false;
  bool _loading = false;
  ProfileModel _profile;
  String _imagePath;


  BehaviorSubject _profileController = BehaviorSubject<ProfileState>();
  get streamProfile => _profileController.stream;

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerNum = TextEditingController();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});


  ProfileController(){
    load();

  }

  load()async{
    _loading = true;
    setState();

    _profile = await UserProvider.get();

    _loading = false;
    setState();

  }
  setImage()async{
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imagePath = (pickedFile.path);
    } else {
      print('No image selected.');
    }
    setState();
  }

  editProfile(){
    controllerNum.text = maskFormatter.maskText(_profile.phone);
    controllerName.text = _profile.name;
    _edit = true;
    setState();
  }
  closeEdit(){
    _imagePath = null;
    _edit = false;
    setState();
  }

  closeAndSaveEdit()async{
    showDialogLoading(AppKeys.scaffoldKey.currentContext);
    String n;
    String p;
    if(controllerName.text != _profile.name && controllerName.text != "")n=controllerName.text;
    if(maskFormatter.getUnmaskedText() != _profile.phone && maskFormatter.getUnmaskedText() .length == 10)p=maskFormatter.getUnmaskedText() ;
    var response = await UserProvider.edit(name: n, phone: p, imagePath: _imagePath);
    closeDialog(AppKeys.scaffoldKey.currentContext);
    _edit  = false;
    load();
  }

  deleteAccount(){
    showDialogRecorder(
        context: AppKeys.scaffoldKey.currentContext,
        title: Text(
          "Точно удалить?",
          style: TextStyle(
              color: cBlack,
              fontWeight: FontWeight.w400,
              fontSize: 20,
              fontFamily: fontFamily),
        ),
        body: Text("Все аудиофайлы исчезнут и восстановить аккаунт будет невозможно", textAlign: TextAlign.center, style: TextStyle(color: cBlack.withOpacity(0.7), fontFamily: fontFamily, fontSize: 14),),
        buttons: [
          DialogIntegronButton(onPressed: (){
            closeDialog(AppKeys.scaffoldKey.currentContext);
            //todo delete account
          }, textButton: Text("Удалить", style: TextStyle(color: cBackground, fontSize: 16, fontFamily: fontFamily, fontWeight: FontWeight.w500),), background: cRed, borderColor: cRed),
          DialogIntegronButton(onPressed: (){
            closeDialog(AppKeys.scaffoldKey.currentContext);
          }, textButton: Text("Нет", style: TextStyle(color: cBlueSoso, fontSize: 16, fontFamily: fontFamily, fontWeight: FontWeight.w400),), borderColor: cBlueSoso),
        ]
    );


  }




  comeOut()async{
    print('ProfileController => Out');
    Navigator.pushReplacementNamed(AppKeys.scaffoldKey.currentContext, Routes.welcomeNew);
    await tokenDB(token: "null");
  }

  setState(){
    ProfileState state = ProfileState(edit: _edit, profile: _profile, loading: _loading, imagePath: _imagePath);
    _profileController.sink.add(state);
  }
  dispose(){
    _profileController.close();
  }

}