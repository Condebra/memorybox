import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Rest/Audio/AudioProvider.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/Utils/DialogsIntegron/DialogLoading.dart';
import 'package:recorder/Utils/app_keys.dart';
import 'package:recorder/models/AudioItem.dart';

editAudio(AudioItem item, GeneralController controller) {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: AppKeys.scaffoldKey.currentContext,
    builder: (context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: EditAudioContent(
          controller: controller,
          item: item,
        ),
      );
    },
  );
}

class EditAudioContent extends StatefulWidget {
  final GeneralController controller;
  final AudioItem item;

  const EditAudioContent({Key key, this.controller, this.item})
      : super(key: key);

  @override
  _EditAudioContentState createState() => _EditAudioContentState();
}

class _EditAudioContentState extends State<EditAudioContent> {
  final _picker = ImagePicker();

  TextEditingController controllerName;

  TextEditingController controllerDesc;

  String path;

  @override
  void initState() {
    super.initState();
    controllerName = TextEditingController(text: widget.item.name);
    controllerDesc = TextEditingController(text: widget.item.description);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      // height: MediaQuery.of(context).size.height * 0.50,
      // width: MediaQuery.of(context).size.width * 0.98,
      decoration: BoxDecoration(
          color: cBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      child: SingleChildScrollView(child: _content()),
    );
  }

  Widget _content() {
    var created = widget.item.createAt.toString();
    var createdDate = created.split(" ").first.split("-").reversed.join(".");
    var createdTime = created.split(" ").last.substring(0, 8);
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () async {
                  // print("!!!!!!!!");
                  String name =
                      controllerName.text.isNotEmpty ? controllerName.text : "";
                  String desc =
                      controllerDesc.text.isNotEmpty ? controllerDesc.text : "";
                  // if(controllerName.text != "") name=controllerName.text;
                  // if(controllerDesc.text != "") desc=controllerDesc.text;
                  showDialogLoading(context);
                  await AudioProvider.edit(
                    widget.item.id ?? widget.item.idS,
                    isLocal: widget.item.id == null ? false : true,
                    name: name,
                    desc: desc,
                    imagePath: path,
                  );
                  closeDialog(context);
                  closeDialog(context);
                  widget.controller.homeController.load();
                },
                child: Text(
                  "Сохранить",
                  style: TextStyle(
                      color: cBlack,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      fontFamily: fontFamily),
                ),
              )
            ],
          ),
          SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  addImage();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.8,
                    height: MediaQuery.of(context).size.width / 1.8,
                    child: path == null
                        ? widget.item.picture == null
                            ? Image.asset(
                                "assets/images/play.png",
                                fit: BoxFit.cover,
                              )
                            : widget.item.id == null
                                ? Image.network(
                                    widget.item.picture,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(widget.item.picture),
                                    fit: BoxFit.cover,
                                  )
                        : Image.file(
                            File(path),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextField(
              textAlign: TextAlign.center,
              controller: controllerName,
              decoration: InputDecoration(
                enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: cBlack)),
                hintStyle: TextStyle(
                    color: cBlack,
                    fontWeight: FontWeight.w400,
                    fontFamily: fontFamily,
                    fontSize: 24),
                hintText: "Название",
              ),
              style: TextStyle(
                  color: cBlack,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily,
                  fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextField(
              textAlign: TextAlign.center,
              controller: controllerDesc,
              decoration: InputDecoration(
                enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: cBlack)),
                hintStyle: TextStyle(
                    color: cBlack,
                    fontWeight: FontWeight.w400,
                    fontFamily: fontFamily,
                    fontSize: 20),
                hintText: "Описание",
              ),
              style: TextStyle(
                  color: cBlack,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamily,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
              "Длительность: ${widget.item.duration.toString().split(".").first.padLeft(8, "0")}",
              style: TextStyle(
                color: cBlack.withOpacity(.8),
                fontWeight: FontWeight.w400,
                fontFamily: fontFamily,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
              "Создано: $createdDate в $createdTime",
              style: TextStyle(
                color: cBlack.withOpacity(.8),
                fontWeight: FontWeight.w400,
                fontFamily: fontFamily,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Text(
                  "Загружено в облако: ",
                  style: TextStyle(
                    color: cBlack.withOpacity(.8),
                    fontWeight: FontWeight.w400,
                    fontFamily: fontFamily,
                    fontSize: 18,
                  ),
                ),
                Text(
                  widget.item.uploadAudio ? "Да" : "Нет",
                  style: TextStyle(
                    color: cBlack.withOpacity(.8),
                    fontWeight: FontWeight.w400,
                    fontFamily: fontFamily,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          // Text("${widget.item.toMap()}", style: TextStyle(color: Colors.black),),
        ],
      ),
    );
  }

  Future addImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      path = (pickedFile.path);
    } else {
      print('No image selected.');
    }
    setState(() {});
  }
}
