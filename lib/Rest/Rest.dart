import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recorder/models/Put.dart';
import 'dart:developer';

bool secureDefault = true;

class Rest {
  Rest._();

  Rest rest = Rest._();

  static Future<dynamic> post(String url, Map<String, dynamic> body,
      {String token}) async {
    // print("post url " + url);
    // print("post body " + body.toString());
    Map<String, String> headers = HashMap();
    headers['Content-type'] = 'application/json';
    headers['Accept'] = 'application/json';
    if (token != null) headers['Authorization'] = 'Bearer $token';

    // print("HEADERS " + headers.toString());
    http.Response response;
    response = await http.post(
      url,
      encoding: Encoding.getByName('utf-8'),
      body: json.encode(body),
      headers: headers,
    );
    log("$url, body: $body", name: "${response.statusCode}",
        error: response.statusCode != 200 ? "${response.body}" : "");
    // print("response "+url+ "  ${response.statusCode}  "+response.body  );
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      // print("res $res");
      return res;
    } else {
      return Put(code: response.statusCode, isLocal: false, message: "");
    }
  }
}
