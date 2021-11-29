import 'package:shared_preferences/shared_preferences.dart';

Future<String> tokenDB({String token}) async {
  final prefs = await SharedPreferences.getInstance();

  if (token == null) {
    var token = prefs.getString("token") ?? "null";
    return token;
  } else {
    await futureAuth(state: false);
    await prefs.setString("token", token);
  }
}

/// check or set(?) auth
Future<bool> futureAuth({bool state}) async {
  final prefs = await SharedPreferences.getInstance();
  print("Future Auth $state");
  if (state == null) {
    var state = prefs.getBool("futureAuth") ?? false;
    return state;
  } else {
    await prefs.setBool("futureAuth", state);
  }
}

Future<bool> uploadProfilePhoto({bool state}) async {
  final prefs = await SharedPreferences.getInstance();
  if (state == null) {
    var state = prefs.getBool("uploadProfilePhoto") ?? false;
    return state;
  } else {
    await prefs.setBool("uploadProfilePhoto", state);
  }
}
