import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/models/ProfileModel.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';
import 'package:provider/provider.dart';

class ProfileImage extends StatefulWidget {
  final bool isEdit;
  final ProfileModel person;
  final String imagePath;

  ProfileImage(
      {@required this.isEdit, @required this.person, @required this.imagePath});

  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  Widget build(BuildContext context) {
    return widget.isEdit ? imageIsEdit(context) : imageNotEdit(context);
  }

  Widget imageNotEdit(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(0, 4),
              blurRadius: 20,
              spreadRadius: 0)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          color: cBlack.withOpacity(0.5),
          width: MediaQuery.of(context).size.width * 0.55,
          height: MediaQuery.of(context).size.width * 0.55,
          child: imgN(),
        ),
      ),
    );
  }

  Widget imgN() {
    if (widget.person.local) {
      if (widget.person.picture != null) {
        return Image(
          image: FileImage(File(widget.person.picture)),
          fit: BoxFit.cover,
        );
      } else {
        return Container();
      }
    } else {
      if (widget.person.picture == null) {
        return Container();
      } else {
        return Image.network(
          widget.person.picture,
          fit: BoxFit.cover,
        );
      }
    }
  }

  Widget imgE() {
    if (widget.imagePath != null) {
      return Image(
        image: FileImage(File(widget.imagePath)),
        fit: BoxFit.cover,
      );
    } else {
      return imgN();
    }
  }

  Widget imageIsEdit(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<GeneralController>().profileController.setImage();
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                offset: Offset(4, 4),
                blurRadius: 20,
                spreadRadius: 0)
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            child: Stack(
              children: [
                Container(
                  width: 216,
                  height: 216,
                  child: imgE(),
                ),
                Container(
                  width: 216,
                  height: 216,
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.5)),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: cBackground.withOpacity(.8), width: 2)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: IconSvg(IconsSvg.camera,
                            color: cBackground, width: 50, height: 50),
                      ),
                    ),
                  ),
                  // ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
