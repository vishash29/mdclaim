// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thirdPartyInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThirdPartyInfo _$ThirdPartyInfoFromJson(Map<String, dynamic> json) {
  print('creating TP Info from $json');
  return ThirdPartyInfo(
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    address: json['address'] as String,
    phoneNumber: json['phoneNumber'] as String,
    registrationNumber: json['registrationNumber'] as String,
    makeAndModel: json['makeAndModel'] as String,
    insurer: json['insurer'] as String,
    damages: json['damages'] as String,
  );
}

Map<String, dynamic> _$ThirdPartyInfoToJson(ThirdPartyInfo instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'registrationNumber': instance.registrationNumber,
      'makeAndModel': instance.makeAndModel,
      'insurer': instance.insurer,
      'damages': instance.damages,
    };
