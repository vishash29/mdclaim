import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'mondServices.dart';
import '../model/user.dart';
import '../model/serviceReturn.dart';
import '../model/policy.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';


class UserService {
  Future<ServiceReturnModel> signInFirebase(User user) async {
    ServiceReturnModel returnModel = ServiceReturnModel();
    returnModel.message = 'Incorrect userid or password';
    returnModel.isSuccess = false;
    returnModel.primaryKey = '';
    try {
      print("Logging in '${user.email}' with password '${user.password}'");
      final FirebaseUser userResult = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: user.email, password: user.password))
          .user;
      print('signed in ${userResult.uid}');
      final User userDetails = (await getUserBasedOnFirebaseId(userResult.uid));
      print('got user details ${userDetails.lastName}');
      returnModel.isSuccess = true;
      returnModel.message = "Welcome back ${userDetails.firstName}";
      returnModel.primaryKey = userResult.uid;
      returnModel.dynamicData = userDetails;
      return returnModel;
    } catch (e) {
      print('Error :$e');
      if (e.toString().indexOf(
              'There is no user record corresponding to this identifier.') >
          0) {
        returnModel.message = "This email does not exist, please register";
      }
      if (e.toString().indexOf('The password is invalid') > 0) {
        returnModel.message = "Please check your password";
      }
      return returnModel;
    }
  }


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
            const IosNotificationSettings(
                sound: true, badge: true, alert: true));
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
    MondServices mondServices=MondServices();
    if (Platform.isAndroid) {
      var result2 = await getAndroidDeviceInfo();
      user.deviceID = result2;
      print('user deviceId ${user.deviceID}');
    } else if (Platform.isIOS) {
      var result2 = await getIOSDeviceInfo();
      user.deviceID = result2;
      print('user deviceId ${user.deviceID}');
    }
    //uncomment to use
    //ServiceReturnModel returnModel=await mondServices.registerUser(user);
    //print('got back $returnModel');
   //   return returnModel;
    return null;
  }
  Future<ServiceReturnModel> registerUserFB(User user) async {
    ServiceReturnModel returnModel = ServiceReturnModel();
    returnModel.message = 'Error adding user';
    returnModel.isSuccess = false;
    returnModel.primaryKey = '';
    print('ST:signing anonymously');
    AuthResult firebaseAuthResultA =
    await FirebaseAuth.instance.signInAnonymously();
    print('Auth Result ${firebaseAuthResultA.user.uid}');
    print('Checking uniqueness of ${user.email}');
    var result = await doesUserEmailAlreadyExists(user.email);
    print("result111 $result");
    if (result == true) {
      returnModel.message = 'User already exists';
      return returnModel;
    }
    ServiceReturnModel returnModel2=await checkPolicyAndUserDetails(user);
    if (!returnModel2.isSuccess){
      return returnModel2;
    }
    try {
      Policy policy=returnModel2.dynamicData;
      user.address.street1=policy.address.street1;
      user.address.city=policy.address.city;
      user.address.postalCd=policy.address.postalCd;
      user.address.stateCd=policy.address.stateCd;
      user.address.countryCd=policy.address.countryCd;
      user.policyNumber=policy.policyNumber; //because user can enter in a diferent case
      print('adding email ${user.email} to firebase ');
      final FirebaseUser firebaseUser =
          (await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: user.email,
            password: user.password,
          ))
              .user;
      print('got firebase userid ${firebaseUser.uid}');
      user.firebaseUID = firebaseUser.uid;
      if (Platform.isAndroid) {
        var result2 = await getAndroidDeviceInfo();
        user.deviceID = result2;
        print('user deviceId ${user.deviceID}');
      } else if (Platform.isIOS) {
        var result2 = await getIOSDeviceInfo();
        user.deviceID = result2;
        print('user deviceId ${user.deviceID}');
      }

      final fireStoreReference = Firestore.instance;
      /*DocumentReference result3 =
      await fireStoreReference.collection(('users')).add(user.toJson());
      print('after adding user got back ${result3.documentID}');
      user.documentID = result3.documentID;
      returnModel.message = "Thank you for registering with mondClaims";
      returnModel.isSuccess = true;
      returnModel.primaryKey = result3.documentID;
      return returnModel;*/
      //return result2.toString();

    } catch (e) {
      print('Error $e');
      return returnModel;
    }
  }

  Future<bool> doesUserEmailAlreadyExists(String name) async {
    print('name $name');
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: name.toLowerCase())
        .limit(1)
        .getDocuments();
    print('waiting?');
    final List<DocumentSnapshot> documents = result.documents;
    print('documents $documents');
    return documents.length >= 1;
  }

  Future<User> getUserBasedOnFirebaseId(String fireBaseId) async {
    print('fireBaseId $fireBaseId');
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('firebaseUID', isEqualTo: fireBaseId)
        .limit(1)
        .getDocuments();
    print('waitingfor user');
    // result.documents
    final List<DocumentSnapshot> documents = result.documents;


    /*User user2=User.setUserFromSnapshot(documents[0]);
    user2.documentID = documents[0].documentID;
    print("Hello ${user2.lastName}");
    print("User PK ${user2.firebaseUID}");
    return user2;*/
    return null;
  }



  Future<ServiceReturnModel> checkPolicyAndUserDetails(User user) async {
    print('user ${user.firstName}');
    ServiceReturnModel returnModel = ServiceReturnModel();
    returnModel.message = 'Error registering user';
    returnModel.isSuccess = false;
    returnModel.primaryKey = '';
    AuthResult firebaseAuthResultA =
        await FirebaseAuth.instance.signInAnonymously();
    print('Auth Result ${firebaseAuthResultA.user.uid}');

    String firstNameLC=user.firstName;
    firstNameLC=firstNameLC.toLowerCase().replaceAll(RegExp("\\s+"),"");
    print("using FNLC $firstNameLC");

    String lastNameLC=user.lastName;
    lastNameLC=lastNameLC.toLowerCase().replaceAll(RegExp("\\s+"),"");
    print("using LNLC $lastNameLC");

    String postalCdLC=user.address.postalCd;
    postalCdLC=postalCdLC.toLowerCase().replaceAll(RegExp("\\s+"),"");
    print("using postalCdLC $postalCdLC");

    String phoneNumberNF=user.phone.replaceAll(RegExp("\\s+"),"");
    print("using phoneNumberNF $phoneNumberNF");

    String policyNumberLC=user.policyNumber;
    policyNumberLC=policyNumberLC.toLowerCase().replaceAll(RegExp("\\s+"),"");
    print("using policyNumberLC $policyNumberLC");

    final QuerySnapshot result = await Firestore.instance
        .collection('policyinfo')
        .where('userInfo.firstNameLC', isEqualTo: firstNameLC)
        .where('userInfo.lastNameLC', isEqualTo: lastNameLC)
        .where('address.postalCdLC', isEqualTo: postalCdLC)
        .where('userInfo.phoneNumberLC', isEqualTo: phoneNumberNF)
        .where('policyNumberLC', isEqualTo: policyNumberLC)
        .limit(1)
        .getDocuments();
    print('waitingfor user');
    // result.documents
    final List<DocumentSnapshot> documents = result.documents;
    if (documents == null || documents.length == 0) {
      print("User details not found");
      returnModel.message = 'Please check the user/policy details';
      return returnModel;
    }
    User userFetched = User();
    print('got ${documents[0]}');
 /*  Policy policy = Policy.fromJson(documents[0].data);
    //policy.setPolicyFromSnapshot(documents[0]);
    print("got Policy Number ${policy.policyNumber}");
    print(
        "got city ${policy.address.city} fn ${policy.userInfo.firstName} expiry date ${policy.policyExpiryDate}");
    returnModel.dynamicData=policy;*/
    returnModel.message ="Success";
        returnModel.isSuccess = true;
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
}
