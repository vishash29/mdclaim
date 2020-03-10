import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable(explicitToJson: true)
class Address {

  String street1;
  String street1LC;
  String street2;
  String street2LC;
  String postalCd;
  String postalCdLC;
  String city;
  String cityLC;
  String stateCd;
  String countryCd;

  Address() {
    this.street1 = null;
    this.street2 = null;
    this.postalCd = null;
    this.city = null;
    this.stateCd = null;
    this.countryCd = null;
  }

  factory Address.fromJson(Map<dynamic, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);

}