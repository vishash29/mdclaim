import '../model/claim.dart';
import 'dart:convert';
import 'networkUtils.dart';
import '../model/claim.dart';
import '../model/serviceReturn.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'dart:typed_data';

Future<ServiceReturnModel> saveClaimToMondCloud(String username, Claim claim) async {


  final msg = jsonEncode(claim.toJson());
  String bodyS=msg.toString();
  print('posting1 $msg');
  print('posting2 $bodyS');


  final claimURL =
      "https://dev.mond-cloud.com/AcmeInsuranceClaims/submitClaim";
  dynamic response = await http.post(claimURL,
      headers: {"Content-Type": "application/json"}, body: msg);

  print("response is ${response.body}");
  print('going to decode3');
  dynamic returnObject= jsonDecode(response.body);
  print('returnObject from mond $returnObject');
  ServiceReturnModel newReturnModel=ServiceReturnModel.fromJson(returnObject);
  if (newReturnModel==null){
    ServiceReturnModel returnModel = ServiceReturnModel();
    returnModel.isSuccess = false;
    returnModel.message = "Claim could not be saved, please contact Tech Support";
    return returnModel;
  }
  print('success fl ${newReturnModel.isSuccess} and message ${newReturnModel.message}');
  return newReturnModel;

}

Future<ServiceReturnModel> getClaimsList(String userId) async {
  Map<String, String> qParams = {'userIdentifier': userId};

  Uri mondUri = Uri.https(
      "dev.mond-cloud.com", "/AcmeInsuranceClaims/getClaimList", qParams);
  ServiceReturnModel returnModel = ServiceReturnModel();
  List<Claim> claimList = List<Claim>();
  dynamic value = await http.get(mondUri);
  print("response is ${value.body}");
  print('going to decode2');
  List<dynamic> list1 = jsonDecode(value.body);
  print("Result $list1");

  list1.forEach((element) {
    Claim claim=Claim();
    claim.claimIdentifier=element['claimIdentifier'];
    claim.setClaimType(element['claimType']);
    print('claim desc ${claim.claimTypeDescription}');
    claim.claimStatusDescription=element['claimStatus'];
    if (element['claimDate'] !=null){
      int claimDateI=element['claimDate'];
      if (claimDateI >0) {
        claim.claimDate = DateTime.fromMillisecondsSinceEpoch(claimDateI);
        print('claimDate is ${claim.claimDate}');
        claim.formatClaimDate();
      }
    }
    claimList.add(claim);
  });
  returnModel.isSuccess = true;
  returnModel.dynamicData=claimList;
  return returnModel;
}

Future<ServiceReturnModel> getClaimDetails(String claimIdentifier,String userId) async {
  Map<String, String> qParams = {'claimNumber': claimIdentifier};

  Uri mondUri = Uri.https(
      "dev.mond-cloud.com", "/AcmeInsuranceClaims/getClaim", qParams);
  ServiceReturnModel returnModel = ServiceReturnModel();
  //Claim claim = Claim();
  dynamic value = await http.get(mondUri);
  print("response is ${value.body}");
  print('going to decode2');
  var element = jsonDecode(value.body);
  print("element $element");
  Claim claim=Claim.fromJson(element);
  print('claim $claim}');
  returnModel.isSuccess = true;
  returnModel.dynamicData=claim;
  return returnModel;
}

Future<ServiceReturnModel> getDocument({String documentOwnerId,String documentType}) async {
  Map<String, String> qParams = {'documentType': documentType,'documentOwnerId':documentOwnerId};

  Uri mondUri = Uri.https(
      "dev.mond-cloud.com", "/AcmeInsurancePolicy/fetchDocument", qParams);
  ServiceReturnModel returnModel = ServiceReturnModel();
 print('invoking $mondUri');
  var value = await http.get(mondUri);
  print('result from getDocument $value');
  print("response is ${value.body}");
  print('going to decode3');
  dynamic returnObject= jsonDecode(value.body);
  print('returnObject $returnObject');
  dynamic document= returnObject['document'];
  if (documentType.compareTo('ProofOfInsurance')==0){
    String base64String=document['documentData'];
    if (base64String==null){
      print('attention, base64String is null');
      return returnModel;
    }
    print('decoding string of length ${base64String.length}');
    returnModel.dynamicData=Image.memory(base64Decode(base64String));
    print('decoded image !!');
    returnModel.isSuccess = true;
    return returnModel;
  }
  else {
    String dir = (await getApplicationDocumentsDirectory()).path;
    print('dir $dir');
    File file = File("$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
    //clientDocument
    File filePath = await file.writeAsBytes(
        base64.decode(document['documentData']));
    returnModel.dynamicData = filePath;
    returnModel.isSuccess = true;
    return returnModel;
  }
}