
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/models/ProfileModel.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:provider/provider.dart';
class ProfileImage extends StatefulWidget {
  bool isEdit;
  ProfileModel person;
  String imagePath;

  ProfileImage({@required this.isEdit, @required this.person, @required this.imagePath});
  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  Widget build(BuildContext context) {
    return widget.isEdit ? imageIsEdit(context) : imageNotEdit(context);
  }

  Widget imageNotEdit(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        color: cBlack.withOpacity(0.5),
          width: MediaQuery.of(context).size.width * 0.55,
          height: MediaQuery.of(context).size.width * 0.55,
          child: imgN(),
      ),
    );
  }

  Widget imgN(){
    if(widget.person.local){
      if(widget.person.picture != null){
        return Image(image:  FileImage(File(widget.person.picture)), fit: BoxFit.cover,);
      }else{
        return Container();
      }
    }else{
      if(widget.person.picture == null){
        return Container();
      }else{
        return Image.network(widget.person.picture, fit: BoxFit.cover,);
      }
    }
  }

  Widget imgE(){

    if(widget.imagePath != null){
      return Image(image:  FileImage(File(widget.imagePath)), fit: BoxFit.cover,);
    }else{
      return imgN();
    }
  }


  Widget imageIsEdit(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<GeneralController>().profileController.setImage();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.55,
              height: MediaQuery.of(context).size.width * 0.55,
              child: imgE()),
          Container(
            width: MediaQuery.of(context).size.width * 0.55,
            height: MediaQuery.of(context).size.width * 0.55,
            decoration: BoxDecoration(color: cBlack.withOpacity(0.5)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 75.0),
              child: IconSvg(IconsSvg.changePhoto,
                  width: 80 / (MediaQuery.of(context).size.width * 0.55)),
            ),
          )
        ]),
      ),
    );
  }
}
