import 'package:cloud_firestore/cloud_firestore.dart';

class ClaimsImageInfo{

  String userId;
  String userFirebaseId;
  int msSinceEpoch;
  int msSinceEpochDatePart;
  String imageType;
  String imageSubType;
  String imageURL;

  ClaimsImageInfo();



  ClaimsImageInfo.fromSnapshot(DocumentSnapshot snapshot) {
    imageURL = snapshot['imageURL'];
    userId = snapshot['userId'];
    userFirebaseId = snapshot['userFirebaseId'];
    imageType = snapshot['imageType'];
    imageSubType = snapshot['imageSubType'];
    msSinceEpoch = snapshot['msSinceEpoch'];
    msSinceEpochDatePart = snapshot['msSinceEpochDatePart'];



    

}

  Map<String, dynamic> toMessageJson() {
    DateTime dtNow = DateTime.now();
    Map<String, dynamic> returnValue = Map<String, dynamic>();
    returnValue['imageURL'] = imageURL;
    returnValue['userId'] = userId;
    returnValue['userFirebaseId'] = userFirebaseId;
    returnValue['imageType'] = imageType;
    returnValue['imageSubType'] = imageSubType;
    returnValue['msSinceEpoch'] = dtNow.millisecondsSinceEpoch;
    DateTime dateTimeTemp = new DateTime(
        dtNow.year, dtNow.month, dtNow.day, 0, 0, 0);
    returnValue['msSinceEpochDatePart'] = dateTimeTemp.millisecondsSinceEpoch;
    return returnValue;
  }
}