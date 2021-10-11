import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/Utils/DialogsIntegron/DialogIntegron.dart';





void showDialogRecorder({
  @required BuildContext context,
  @required Widget title,
  @required Widget body,
  List<DialogIntegronButton> buttons,
  Color dialogBackGroundColor,
}) {


  Color backGroundColor = dialogBackGroundColor ?? cBackground;

  int counter = 0;
  if(buttons != null){
    if(buttons.length > 1)counter = 2;
    else counter = 1;
  }
  GlobalKey key = new GlobalKey();






  Widget _buttons(double height){

    return counter == 0?SizedBox(height: MediaQuery.of(context).size.width*0.08,):
    Container(

      height: height+1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Divider(color: cBlack.withOpacity(0.5),height: 1,),
          counter ==2?Container(
            height: height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  enableFeedback: false,
                  onTap: (){
                    buttons[0].onPressed == null?null:buttons[0].onPressed();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      border: Border.all(color: buttons[0].borderColor??cBlack),
                      color: buttons[0].background??cBackground
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 12),
                      child: buttons[0].textButton,
                    ),
                  ),
                ),
                InkWell(
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  enableFeedback: false,
                  onTap: (){
                    buttons[1].onPressed == null?null:buttons[1].onPressed();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        border: Border.all(color: buttons[1].borderColor??cBlack),
                        color: buttons[1].background??cBackground
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 12),
                      child: buttons[1].textButton,
                    ),
                  ),
                ),
              ],
            ),
          ):
          InkWell(
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            enableFeedback: false,
            onTap: (){
              buttons[0].onPressed == null?null:buttons[0].onPressed();
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  border: Border.all(color: buttons[0].borderColor??cBlack),
                  color: buttons[0].background??cBackground
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                child: buttons[0].textButton,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(){
    return Padding(
      padding:  EdgeInsets.only(top: MediaQuery.of(context).size.width*0.08,),
      child: Column(
        mainAxisAlignment: counter >0?MainAxisAlignment.spaceBetween:MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only( right: 12,left: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                title,
                SizedBox(height: 12,),
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
          builder:(con)=> GestureDetector(
            onTap: (){
              print(MediaQuery.of(context).size.width*0.88);
            },
            child: Container(

              decoration: BoxDecoration(
                color:backGroundColor,
                borderRadius: BorderRadius.circular(30),
              ),
              width: MediaQuery.of(context).size.width*0.77,
              height: MediaQuery.of(context).size.width*0.77*0.72,

              child: _content(),
            ),
          ),
        ),
      );
    },
  );



}


