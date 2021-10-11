part of 'DialogIntegron.dart';

showDialogIntegronError(BuildContext context, String text)async{
  await showDialogIntegron(context: context,
      title: Text("Сообщение",  style: TextStyle(color: cBlack, fontSize: 16,fontFamily: fontFamily),),
      body: Text(text,
        style: TextStyle(color: cBlack, fontSize: 16, fontFamily: fontFamily),
        textAlign: TextAlign.center, ));
}