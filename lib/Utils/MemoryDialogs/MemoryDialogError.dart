part of 'MemoryDialog.dart';

showMemoryDialogError(BuildContext context, String text) async {
  await showMemoryDialog(
    context: context,
    title: Text(
      "Сообщение",
      style: TextStyle(color: cBlack, fontSize: 16, fontFamily: fontFamily),
    ),
    body: Text(
      text,
      style: TextStyle(color: cBlack, fontSize: 16, fontFamily: fontFamily),
      textAlign: TextAlign.center,
    ),
  );
}
