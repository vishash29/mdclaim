import 'package:http/http.dart';
import 'dart:convert';
import 'httpRequestProtocol.dart';


class HttpSession {
  final Client _client;

  HttpSession(this._client);

  @override
  Future<void> request(
      {HttpRequestProtocol service}) async {
    final request = HttpRequest(service);

    final requestResponse = await _client.send(request);

    if (requestResponse.statusCode >= 200 &&
        requestResponse.statusCode <= 299) {
      final data = await requestResponse.stream.transform(utf8.decoder).join();
     print('receoved $data');
    } else {
      final Map<String, dynamic> responseError = {
        "error_code": "${requestResponse.statusCode}",
        "description": "Error retrieving data from the Server."
      };

      print('error ${requestResponse.statusCode} ');
    }
  }
}