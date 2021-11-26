

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recorder/Style.dart';

void showDialogLoading(BuildContext context){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: cBackground,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25)
            ),

          ),
          width: 0,
          height: 80,
          child: Center(
            child: new CircularProgressIndicator(
              // backgroundColor: cDefault,
            ),
          ),
        ),

      );
    },
  );
}

void closeDialog(BuildContext context){
  Navigator.of(context).pop();
}