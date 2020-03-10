import 'thirdPartyInfo.dart';
import 'address.dart';
import 'dart:convert';
import '../common/dateTimeUtils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'claim.g.dart';

@JsonSerializable(explicitToJson: true)
class Claim {
  String claimIdentifier;
  String policyNumber;
  String userIdentifier;
  String claimType;

  @JsonKey(ignore: true)
  String claimTypeDescription;
  @JsonKey(fromJson: _dateTimeFromEpochUs, toJson: _dateTimeToEpochUs)
  DateTime claimDate;
  @JsonKey(ignore: true)
  String claimDateFmt;

  @JsonKey(ignore: true)
  String claimStatusDescription;
  @JsonKey(ignore: true)
  String settlementStatusDescription;

  bool wasBusinessUse;
  bool wasReportedToPolice;
  bool wasTakenToHospital;
  String hospitalName;
  String reportNumber;

  @JsonKey(fromJson: _dateTimeFromEpochUs, toJson: _dateTimeToEpochUs)
  DateTime accidentDateTime;

  String accidentDateTimeS;
  String stateOfRoad;
  String accidentDetails;
  String injuriesSustained;
  @JsonKey(ignore: true)
  int speedUOM; // OR
  String vehicleSpeedS;
  String vehicleSpeedUOM;

  String witnessName1;
  String witnessAddress1;
  String whoWasAtFault;

  //not used now
  String witnessName2;
  String witnessAddress2;

  //accident location
  @JsonKey(ignore: true)
  Address accidentAddress;
  String accidentAddressS; // will have the full address

  //just to display information
  @JsonKey(ignore: true)
  String claimInfo;
  @JsonKey(ignore: true)
  bool isInfo;
  @JsonKey(ignore: true)
  bool isNewClaim;

  List<ThirdPartyInfo> thirdPartyInfoList;

  Claim() {
    wasBusinessUse = false;
    wasReportedToPolice = false;
    stateOfRoad = 'SM';
    whoWasAtFault = 'OP';
    vehicleSpeedUOM = "KMH";
    claimType = '01';
    speedUOM = 1;
    wasTakenToHospital = false;
    accidentAddressS = ' ';
    isInfo = false;
    isNewClaim = false;
    claimDateFmt = ' ';
    accidentDateTimeS = ' ';
    claimTypeDescription = ' ';
  }

  factory Claim.fromJson(Map<String, dynamic> json) => _$ClaimFromJson(json);
  Map<String, dynamic> toJson() => _$ClaimToJson(this);

  static DateTime _dateTimeFromEpochUs(int us) =>
      new DateTime.fromMillisecondsSinceEpoch(us);

  static int _dateTimeToEpochUs(DateTime dateTime) => dateTime.millisecondsSinceEpoch;

  String toJsonDelete() {
    Map<String, dynamic> claimJson = Map<String, String>();

    claimJson['policyNumber'] = policyNumber;
    claimJson['claimSubmittedBy'] = userIdentifier;
    claimJson['accidentDateTime'] = accidentDateTime.toIso8601String();
   // claimJson['accidentDateTimeS'] = accidentDateTimeS;
    claimJson['claimType'] = claimType;
    claimJson['stateOfRoad'] = stateOfRoad;
    claimJson['vehicleSpeedS'] = vehicleSpeedS;
    claimJson['vehicleSpeedUOM'] = vehicleSpeedUOM;
    claimJson['accidentDetails'] = accidentDetails;
    claimJson['injuriesSustained'] = injuriesSustained;
    claimJson['wasTakenToHospital'] = wasTakenToHospital.toString();
    claimJson['whoWasAtFault'] = whoWasAtFault;

    claimJson['accidentAddressS'] = accidentAddressS;
    claimJson['witnessName1'] = witnessName1;
    claimJson['witnessAddress1'] = witnessAddress1;
    claimJson['witnessName2'] = witnessName2;
    claimJson['witnessAddress2'] = witnessAddress2;
    claimJson['policyNumber'] = policyNumber;
    claimJson['accidentDetails'] = accidentDetails;

    if (thirdPartyInfoList !=null && thirdPartyInfoList.length>0){
      Map<String, String> thirdPartyInfo = Map<String, String>();
      thirdPartyInfo['firstName'] = thirdPartyInfoList[0].firstName;
      thirdPartyInfo['lastName'] = thirdPartyInfoList[0].lastName;
      thirdPartyInfo['address'] = thirdPartyInfoList[0].address;
      thirdPartyInfo['insurer'] = thirdPartyInfoList[0].insurer;
      thirdPartyInfo['makeAndModel'] = thirdPartyInfoList[0].makeAndModel;
      thirdPartyInfo['damages'] = thirdPartyInfoList[0].damages;
      String thirdPartyJson=jsonEncode(thirdPartyInfo);
      print('thirdParty $thirdPartyJson');
      claimJson['thirdPartyInfoList']=thirdPartyInfoList;
    }

    return jsonEncode(claimJson);
  }

  void fromJson(var element){
    claimIdentifier=element['claimIdentifier'];
    setClaimType(element['claimType']);
    print('claim desc ${claimTypeDescription}');
    claimStatusDescription=element['claimStatus'];
    if (element['claimDate'] !=null){
      int claimDateI=element['claimDate'];
      if (claimDateI >0) {
        claimDate = DateTime.fromMillisecondsSinceEpoch(claimDateI);
        print('claimDate is ${claimDate}');
        formatClaimDate();
      }
    }
    stateOfRoad=element['stateOfRoad'];

  }
  setClaimType(String newValue) {
    claimType = newValue;
    if (claimType == null) return;
    if (claimType.compareTo('01') == 0) {
      claimTypeDescription = 'Collision';
      return;
    }
    else if (claimType.compareTo('02') == 0) {
      claimTypeDescription = 'Fire';
      return;
    }
    else if (claimType.compareTo('03') == 0) {
      claimTypeDescription = 'Hit & Run';
      return;
    }
    else if (claimType.compareTo('04') == 0) {
      claimTypeDescription = 'Windshield';
      return;
    }
    else if (claimType.compareTo('05') == 0) {
      claimTypeDescription = 'Theft';
      return;
    }
    else if (claimType.compareTo('06') == 0) {
      claimTypeDescription = 'Other';
      return;
    }
    else
      claimTypeDescription = 'Unknown';
    print('unknown claim type \'$claimType\'');
  }

  formatClaimDate(){

    if (claimDate !=null)
       claimDateFmt=DateUtils().getFormattedDate(claimDate);
  }
}
