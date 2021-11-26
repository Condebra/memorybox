
import 'package:intl/intl.dart';

String txTimeParseDate(String time){
  DateTime date = DateFormat("yyyy-MM-ddTHH:mm:ss.vvvZ").parse(time);
  date = date.add(Duration(hours: 3)); // +3 hour to MSK
  DateTime dateNow= DateTime.now();

  if(date.year == DateTime.now().year && date.month == DateTime.now().month&& date.day == DateTime.now().day){
    return "Сегодня";
  }else if(date.year == DateTime.now().year && date.month == DateTime.now().month&& date.day == DateTime.now().day-1){
    return "Вчера";
  }
  return date.day.toString()+"."+date.month.toString();
}

String txTimeParseTime(String time){
  DateTime date = DateFormat("yyyy-MM-ddTHH:mm:ss.vvvZ").parse(time);
  date = date.add(Duration(hours: 3));
  DateTime dateNow= DateTime.now();

  return setDateMode(date);
}

String setDateMode(DateTime date) {
  String ye, mo, da, ho, mi;
  ye = date.year.toString();
  mo = date.month < 10 ? "0" + date.month.toString() : date.month.toString();
  da = date.day < 10 ? "0" + date.day.toString() : date.day.toString();
  ho = date.hour < 10 ? "0" + date.hour.toString() : date.hour.toString();
  mi = date.minute % 60 < 10 ? "0" + (date.minute % 60).toString() : (date.minute % 60).toString();
  return da+ "."+mo+" "+ho + ":" + mi;
}


DateTime dateParse(String time){
  DateTime date = DateFormat("yyyy-MM-ddTHH:mm:ss.vvvZ").parse(time);
  date = date.add(Duration(hours: 3));
  DateTime dateNow= DateTime.now();

  return date;
}


String month(String month) {
  switch (month) {
    case "1":
      return "Янв.";
      break;
    case "2":
      return "Фев.";
      break;
    case "3":
      return "Марта";
      break;
    case "4":
      return "Апр.";
      break;
    case "5":
      return "Мая";
      break;
    case "6":
      return "Июня";
      break;
    case "7":
      return "Июля";
      break;
    case "8":
      return "Авг.";
      break;
    case "9":
      return "Сен.";
      break;
    case "10":
      return "Окт.";
      break;
    case "11":
      return "Ноя.";
      break;
    case "12":
      return "Дек.";
      break;
  }
}

String time(Duration duration){
  String nullCheck(int c){
    if(c<10){
      return "0${c}";
    }else{return c.toString();};
  }
  String t= "";
  if(duration == null){
    return t;
  }else{
    if(duration.inHours > 0){
      t+="${duration.inHours}:${nullCheck(duration.inMinutes%60)}:${nullCheck(duration.inSeconds%60)}";
    }else if(duration.inMinutes>0){
      t+="${duration.inMinutes%60}:${nullCheck(duration.inSeconds%60)}";
    }else{
      t+="00:${nullCheck(duration.inSeconds%60)}";
    }

  }
  return t;
}