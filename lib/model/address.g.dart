// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address()
    ..street1 = json['street1'] as String
    ..street1LC = json['street1LC'] as String
    ..street2 = json['street2'] as String
    ..street2LC = json['street2LC'] as String
    ..postalCd = json['postalCd'] as String
    ..postalCdLC = json['postalCdLC'] as String
    ..city = json['city'] as String
    ..cityLC = json['cityLC'] as String
    ..stateCd = json['stateCd'] as String
    ..countryCd = json['countryCd'] as String;
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'street1': instance.street1,
      'street1LC': instance.street1LC,
      'street2': instance.street2,
      'street2LC': instance.street2LC,
      'postalCd': instance.postalCd,
      'postalCdLC': instance.postalCdLC,
      'city': instance.city,
      'cityLC': instance.cityLC,
      'stateCd': instance.stateCd,
      'countryCd': instance.countryCd,
    };
