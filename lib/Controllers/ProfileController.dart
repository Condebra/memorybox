import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:recorder/Controllers/States/ProfileState.dart';
import 'package:recorder/DB/DB.dart';
import 'package:recorder/Rest/Audio/AudioProvider.dart';
import 'package:recorder/Rest/User/UserProvider.dart';
import 'package:recorder/Routes.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/Utils/MemoryDialogs/MemoryDialog.dart';
import 'package:recorder/Utils/MemoryDialogs/DialogLoading.dart';
import 'package:recorder/Utils/MemoryDialogs/DialogRecorder.dart';
import 'package:recorder/Utils/app_keys.dart';
import 'package:recorder/Utils/tokenDB.dart';
import 'package:recorder/models/ProfileModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recorder/generated/l10n.dart';

class ProfileController {
  final _picker = ImagePicker();

  bool _edit = false;
  bool _loading = false;
  ProfileModel profile;
  String _imagePath;
  SharedPreferences prefs;
  bool subStatus = false;

  BehaviorSubject _profileController = BehaviorSubject<ProfileState>();

  get streamProfile => _profileController.stream;

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerNum = TextEditingController();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});

  ProfileController() {
    load();
  }

  load() async {
    prefs = await SharedPreferences.getInstance();
    // print("prefs status ${prefs.getString("status")}");
    if (prefs.getString("status") == "premium")
      subStatus = true;
    else
      prefs.setString("status", "free");
    log("${prefs.getString("status")}", name: "sub");
    _loading = true;
    profile = await UserProvider.get();
    _loading = false;
    setState();
  }

  setImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imagePath = (pickedFile.path);
    } else {
      print('No image selected.');
    }
    setState();
  }

  editProfile() {
    controllerNum.text = maskFormatter.maskText(profile.phone);
    controllerName.text = profile.name;
    _edit = true;
    setState();
  }

  cancelEdit() {
    _imagePath = null;
    _edit = false;
    setState();
  }

  closeAndSaveEdit() async {
    showDialogLoading(AppKeys.scaffoldKey.currentContext);
    String n;
    String p;
    if (controllerName.text != profile.name && controllerName.text != "")
      n = controllerName.text;
    if (maskFormatter.getUnmaskedText() != profile.phone &&
        maskFormatter.getUnmaskedText().length == 10)
      p = maskFormatter.getUnmaskedText();
    await UserProvider.edit(name: n, phone: p, imagePath: _imagePath);
    closeDialog(AppKeys.scaffoldKey.currentContext);
    _edit = false;
    load();
  }

  bool checkLogin() {
    log("${profile.anonimus}", name: "check login");
    if (profile?.anonimus == true) return false;
    return true;
  }

  deleteAccount(BuildContext context) {
    showDialogRecorder(
      context: context,
      title: Text(
        S.current.sure,
        style: TextStyle(
          color: cBlack,
          fontWeight: FontWeight.w400,
          fontSize: 20,
          fontFamily: fontFamily,
        ),
      ),
      body: Text(
        S.current.delete_account_body,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: cBlack.withOpacity(0.7),
          fontFamily: fontFamily,
          fontSize: 14,
        ),
      ),
      buttons: [
        MemoryDialogButton(
          onPressed: () {
            deleteProfile(context);
            closeDialog(context);
          },
          textButton: Text(
            S.current.delete,
            style: TextStyle(
              color: cBackground,
              fontSize: 16,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w500,
            ),
          ),
          background: cRed,
          borderColor: cRed,
        ),
        MemoryDialogButton(
          onPressed: () {
            closeDialog(context);
          },
          textButton: Text(
            S.current.no,
            style: TextStyle(
              color: cBlueSoso,
              fontSize: 16,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
          borderColor: cBlueSoso,
        ),
      ],
    );
  }

  logOutDialog(BuildContext context, {bool auth = true}) {
    showDialogRecorder(
      context: context,
      title: Text(
        S.current.sure,
        style: TextStyle(
          color: cBlack,
          fontWeight: FontWeight.w400,
          fontSize: 20,
          fontFamily: fontFamily,
        ),
      ),
      body: Text(
        S.current.not_uploaded_audio,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: cBlack.withOpacity(0.7),
          fontFamily: fontFamily,
          fontSize: 14,
        ),
      ),
      buttons: [
        if (auth)
          MemoryDialogButton(
            onPressed: () {
              uploadAudioAndLogOut(context);
              closeDialog(context);
            },
            textButton: Text(
              S.current.upload_exit,
              style: TextStyle(
                color: cBlueSoso,
                fontSize: 13,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w500,
              ),
            ),
            borderColor: cBlueSoso,
          ),
        // else SizedBox(),
        MemoryDialogButton(
          onPressed: () {
            logOut(context);
            // closeDialog(context);
          },
          textButton: Text(
            S.current.exit,
            style: TextStyle(
              color: cBackground,
              fontSize: 14,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
          background: cRed,
          borderColor: cRed,
        ),
      ],
    );
  }

  uploadAudioAndLogOut(context) async {
    var list = await AudioProvider.getAudios();
    if (list != null && list.isNotEmpty)
      list.forEach((element) async {
        await AudioProvider.upload(-1, audioItem: element);
      });
    logOut(context);
  }

  logOut(BuildContext context) async {
    // print('ProfileController => Out');
    // Navigator.pushReplacementNamed(context, Routes.welcomeNew);
    // Get.snackbar("logout", "u r no longer logged in");
    Get.offAllNamed("/login");
    profile = null;
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await DBProvider.db.deleteDataFromDB();
    await tokenDB(token: "null");
    setState();
  }

  deleteProfile(BuildContext context) async {
    // var attempt = await UserProvider.delete();
    // print("attempt $attempt");
    if (await UserProvider.delete()) {
      logOut(context);
      Get.snackbar(
        S.current.delete_profile,
        S.current.delete_account_success,
      );
    } else {
      Get.snackbar(
        S.current.delete_profile,
        S.current.delete_account_error,
      );
    }
  }

  setState() {
    ProfileState state = ProfileState(
      edit: _edit,
      profile: profile,
      loading: _loading,
      imagePath: _imagePath,
      subStatus: subStatus,
    );
    _profileController.sink.add(state);
  }

  dispose() {
    _profileController.close();
  }
}
