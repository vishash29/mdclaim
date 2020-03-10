import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'mondServices.dart';
import '../model/user.dart';
import '../model/serviceReturn.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'networkUtils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getDeviceInfo() async {
  String identifier;
  String deviceToken;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  try {
    print('getting device info');
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      identifier = build.id.toString();

      print('waiting for device token');
      firebaseMessaging.getToken().then((token) {
        print('token $token');
        deviceToken = token;
      });
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      identifier = data.identifierForVendor;
      firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
      firebaseMessaging.onIosSettingsRegistered
          .listen(((IosNotificationSettings settings) {
        print('settings $settings');
      }));
      firebaseMessaging.getToken().then((token) {
        print('token $token');
        deviceToken = token;
      });
    }
    print('returning device token $deviceToken');
    return deviceToken;
  } on PlatformException {
    print("Failed to get platform version");
    return null;
  }
}

Future<String> getAndroidDeviceInfo() async {
  String deviceToken;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  print('getting device info');
  var build = await deviceInfoPlugin.androidInfo;
  print('waiting for device token');
  final result = firebaseMessaging.getToken();
  print('waiting?');
  print('token $result');
  return result;
}

Future<String> getIOSDeviceInfo() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  print('getting device info');
  var data = await deviceInfoPlugin.iosInfo;

  firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true));
  firebaseMessaging.onIosSettingsRegistered
      .listen(((IosNotificationSettings settings) {
    print('settings $settings');
  }));
  final result = firebaseMessaging.getToken();
  print('waiting?');
  print('token $result');
  return result;
}

Future<ServiceReturnModel> registerUser(User user) async {
  print('ST:registeringMond user');

  if (Platform.isAndroid) {
    var result2 = await getAndroidDeviceInfo();
    user.deviceID = result2;
    print('user deviceId ${user.deviceID}');
  } else if (Platform.isIOS) {
    var result2 = await getIOSDeviceInfo();
    user.deviceID = result2;
    print('user deviceId ${user.deviceID}');
  }
  Map<String, String> headers = Map<String, String>();
  headers['Content-Type'] = 'application/json';

  Map<String, String> userInfo = Map<String, String>();
  userInfo['policyNumber'] = user.policyNumber;
  userInfo['firstName'] = user.firstName;
  userInfo['lastName'] = user.lastName;

  String postalCdLC =
      user.address.postalCd.toLowerCase().replaceAll(RegExp("\\s+"), "");
  print("using postalCdLC $postalCdLC");
  userInfo['postalCd'] = postalCdLC;

  String phoneNumberNF = user.phone.replaceAll(RegExp("\\s+"), "");
  print("using phoneNumberNF $phoneNumberNF");
  userInfo['phoneNumber'] = phoneNumberNF;
  userInfo['email'] = user.email;
  userInfo['password'] = user.password;
  userInfo['deviceId'] = user.deviceID;
  userInfo['userRole'] = user.role;

  NetworkUtil _netUtil = new NetworkUtil();
  ServiceReturnModel returnModel = ServiceReturnModel();
  returnModel.isSuccess=false;
  var uri = Uri.https(
      'dev.mond-cloud.com', '/AcmeInsuranceClaimsUser/registerUser', userInfo);

  final msg = jsonEncode(userInfo);

  print('userInfo $msg');
  print('URI $uri');
  print('headers $headers');
  try {
    var returnValue = await _netUtil.post(uri, headers: headers, body: msg);
    print('result from mond $returnValue');
print('decoding result');
    String message= returnValue['message'];
    print('message1 $message');
    returnModel.message=message;

    bool successFl=returnValue['successFl'];
    returnModel.isSuccess=successFl;

    print('sucessfl $successFl');
    if (!successFl && message !=null){
      return returnModel;
    }
    User user = User();
    user.fromJson(returnValue['user']);
    if (user.mondIdentifier == null ||
        user.mondIdentifier.compareTo('-1') == 0) {
      returnModel.isSuccess = false;
      returnModel.message = "Please check your email or password";
      return returnModel;
    }
    if (user.mondIdentifier != null && user.mondIdentifier.length > 2) {
      returnModel.isSuccess = true;
      returnModel.dynamicData = user;

      return returnModel;
    }
    returnModel.isSuccess = false;
    returnModel.message = "Invalid email or password";
    //returnModel.dynamicData=;
    print('returning retModel $returnModel');
  } catch (error) {
    print('error $error');
  }
}

Future<ServiceReturnModel> loginToMondCloud(
    String username, String password) async {
  Map<String, String> qParams = {'userName': username, 'password': password};
  Uri mondUri = Uri.https("dev.mond-cloud.com",
      "/AcmeInsuranceClaimsUser/authenticateUser", qParams);
  ServiceReturnModel returnModel = ServiceReturnModel();
  returnModel.isSuccess = false;
  returnModel.message = "The service is down, please try later";
  print('getting $mondUri');
  var value = await http.get(mondUri);
  print("response is ${value}");
  try {
    var result = jsonDecode(value.body);
    print('result is $result');
    User user = User();
    user.fromJson(result['user']);
    if (user.mondIdentifier == null ||
        user.mondIdentifier.compareTo('-1') == 0) {
      returnModel.isSuccess = false;
      returnModel.message = "Please check your email or password";
      return returnModel;
    }
    if (user.mondIdentifier != null && user.mondIdentifier.length > 2) {
      returnModel.isSuccess = true;
      returnModel.dynamicData = user;
      return returnModel;
    }
    returnModel.isSuccess = false;
    returnModel.message = "Invalid email or password";
    //returnModel.dynamicData=;
    print('returning retModel $returnModel');
  } catch (err) {
    print('error $err');
  }
  returnModel.isSuccess = false;
  print('going to return $returnModel');

  return returnModel;
}

Future<String> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  // Checking if email and name is null
  assert(user.uid != null);
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);

  String uid = user.uid;
  String name = user.displayName;
  String email = user.email;
  String imageUrl = user.photoUrl;

  print("UID $uid name $name email $email imageURL $imageUrl");

  // Only taking the first part of the name, i.e., First Name
  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  /*SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', true);
    authSignedIn = true;*/

  return 'signInWithGoogle succeeded: $user';
}
