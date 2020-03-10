import 'package:http/http.dart';
import 'dart:convert';
import 'networkUtils.dart';
import '../model/user.dart';
import '../model/serviceReturn.dart';

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class MondServices {



Future<User> fetchPolicy(User user) {
  NetworkUtil _netUtil = new NetworkUtil();
  final policyURL =
      "https://dev.mond-cloud.com/AcmeInsuranceClaims/fetchPolicyBasedOnNameNumber";
  print('going to URL $policyURL');
  Map<String, String> qParams = {
    'policyNumber': user.policyNumber,
    'firstName': user.firstName,
    'lastName': user.lastName,
    'postalCd': user.address.postalCd,
    'phoneNumber': user.phone
  };
  return _netUtil.get(policyURL, qParams).then((dynamic res) {
    print('result from mond $res');
    if (res["error"]) throw new Exception(res["error_msg"]);
    return null;
  });
}


}
