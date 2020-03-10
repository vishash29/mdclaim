// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Claim _$ClaimFromJson(Map<String, dynamic> json) {
  return Claim()
    ..claimIdentifier = json['claimIdentifier'] as String
    ..policyNumber = json['policyNumber'] as String
    ..userIdentifier = json['userIdentifier'] as String
    ..claimType = json['claimType'] as String
    ..claimDate = Claim._dateTimeFromEpochUs(json['claimDate'] as int)
    ..wasBusinessUse = json['wasBusinessUse'] as bool
    ..wasReportedToPolice = json['wasReportedToPolice'] as bool
    ..wasTakenToHospital = json['wasTakenToHospital'] as bool
    ..hospitalName = json['hospitalName'] as String
    ..reportNumber = json['reportNumber'] as String
    ..accidentDateTime =
        Claim._dateTimeFromEpochUs(json['accidentDateTime'] as int)
    ..accidentDateTimeS = json['accidentDateTimeS'] as String
    ..stateOfRoad = json['stateOfRoad'] as String
    ..accidentDetails = json['accidentDetails'] as String
    ..injuriesSustained = json['injuriesSustained'] as String
    ..vehicleSpeedS = json['vehicleSpeedS'] as String
    ..vehicleSpeedUOM = json['vehicleSpeedUOM'] as String
    ..witnessName1 = json['witnessName1'] as String
    ..witnessAddress1 = json['witnessAddress1'] as String
    ..whoWasAtFault = json['whoWasAtFault'] as String
    ..witnessName2 = json['witnessName2'] as String
    ..witnessAddress2 = json['witnessAddress2'] as String
    ..accidentAddressS = json['accidentAddressS'] as String
    ..thirdPartyInfoList = (json['thirdPartyInfoList'] as List)
        ?.map((e) => e == null
            ? null
            : ThirdPartyInfo.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ClaimToJson(Claim instance) => <String, dynamic>{
      'claimIdentifier': instance.claimIdentifier,
      'policyNumber': instance.policyNumber,
      'userIdentifier': instance.userIdentifier,
      'claimType': instance.claimType,
      'claimDate': Claim._dateTimeToEpochUs(instance.claimDate),
      'wasBusinessUse': instance.wasBusinessUse,
      'wasReportedToPolice': instance.wasReportedToPolice,
      'wasTakenToHospital': instance.wasTakenToHospital,
      'hospitalName': instance.hospitalName,
      'reportNumber': instance.reportNumber,
      'accidentDateTime': Claim._dateTimeToEpochUs(instance.accidentDateTime),
      'accidentDateTimeS': instance.accidentDateTimeS,
      'stateOfRoad': instance.stateOfRoad,
      'accidentDetails': instance.accidentDetails,
      'injuriesSustained': instance.injuriesSustained,
      'vehicleSpeedS': instance.vehicleSpeedS,
      'vehicleSpeedUOM': instance.vehicleSpeedUOM,
      'witnessName1': instance.witnessName1,
      'witnessAddress1': instance.witnessAddress1,
      'whoWasAtFault': instance.whoWasAtFault,
      'witnessName2': instance.witnessName2,
      'witnessAddress2': instance.witnessAddress2,
      'accidentAddressS': instance.accidentAddressS,
      'thirdPartyInfoList':
          instance.thirdPartyInfoList?.map((e) => e?.toJson())?.toList(),
    };
