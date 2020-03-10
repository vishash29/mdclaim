import 'address.dart';
import 'user.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Policy {

  String policyNumber;
  String policyNumberLC;
  String policyPdfURLuploadedByInsurer;
  String policyPdfURLuploadedByUser;
  String proofOfInsuranceURLuploadedByInsurer;
  String proofOfInsuranceURLuploadedByUser;

  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _DateTimeToTimestamp)
  DateTime policyExpiryDate;

  String policyIdentifierInsurer;
  String policyIdentifier;

  Address address;
  User userInfo;

  Policy(){
    address=Address();
    userInfo=User();
  }


  static DateTime _dateTimeFromTimestamp(Timestamp ts) {
    print('going to convert Timestmp $ts to datetime');
    DateTime d1=DateTime.fromMillisecondsSinceEpoch(ts.millisecondsSinceEpoch);
    print('d1 $d1');
    return d1;
  }

  static Timestamp _DateTimeToTimestamp(DateTime dateTime) {
    print('going to convert DateTime $dateTime to Timestamp');
    return null;
  }

  String getPolicyInfo(){
    return 'PN '+policyNumber+ ' City '+address.postalCd+ ' FN '+userInfo.firstName+ ' PI '+policyIdentifier;
  }
}