import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/Utils/MemoryDialogs/MemoryDialog.dart';

void showDialogRecorder({
  @required BuildContext context,
  @required Widget title,
  @required Widget body,
  List<MemoryDialogButton> buttons,
  Color dialogBackGroundColor,
}) {
  Color backGroundColor = dialogBackGroundColor ?? cBackground;

  int counter = 0;
  if (buttons != null) {
    if (buttons.length > 2) buttons = buttons.sublist(0, 1);
    counter = buttons.length;
  }

  Widget _buttons(double height) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          counter,
          (index) => GestureDetector(
            onTap: buttons[index].onPressed,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  border:
                      Border.all(color: buttons[index].borderColor ?? cBlack),
                  color: buttons[index].background ?? cBackground),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16, //12
                  vertical: 10, //6
                ),
                child: buttons[index].textButton,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content() {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.width * 0.08,
      ),
      child: Column(
        mainAxisAlignment: counter > 0
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 12, left: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                title,
                SizedBox(
                  height: 12,
                ),
                body,
              ],
            ),
          ),
          _buttons(70),
        ],
      ),
    );
  }

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.all(0),
        backgroundColor: Colors.transparent,
        child: Builder(
          builder: (con) => GestureDetector(
            onTap: () {
              print(MediaQuery.of(context).size.width * 0.88);
            },
            child: Container(
              decoration: BoxDecoration(
                color: backGroundColor,
                borderRadius: BorderRadius.circular(30),
              ),
              width: MediaQuery.of(context).size.width * 0.77,
              height: MediaQuery.of(context).size.width * 0.77 * 0.72,
              child: _content(),
            ),
          ),
        ),
      );
    },
  );
}
