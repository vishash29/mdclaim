import 'address.dart';
import 'package:json_annotation/json_annotation.dart';


class User {
  String firstName;
  String firstNameLC;
  String lastName;
  String lastNameLC;
  String phone;
  String phoneNF; //no formatting
  String email; // will always be in lowercase
  String firebaseUID;
  String mondIdentifier;
  String deviceID;
  // 'C' means customer, 'I' means Insurer
  String role;
  String profileURL;
  String documentID;
  bool loginWithApple;
  bool loginWithAppleId;
  bool loginWithGoogle;
  String policyPdfURLuploadedbyInsurer;
  String policyPdfURLuploadedbyUser;
  String insurerIdentifier;
  Address address;

  @JsonKey(ignore: true)
  String password;
  String policyNumber;


  User() {
    this.loginWithApple = false;
    this.loginWithAppleId = false;
    this.loginWithAppleId = false;
    address=Address();
  }

  void fromJson(var element){
    if (element==null){
      print('received null, cannot create user');
      return;
    }
    mondIdentifier=element['userId'];
    firstName=element['firstName'];
    lastName=element['lastName'];
    email=element['email'];
    policyNumber=element['policyNumber'];
    role=element['role'];
    deviceID=element['deviceId'];
  }


}
