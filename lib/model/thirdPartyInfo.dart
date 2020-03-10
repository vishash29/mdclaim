import 'package:json_annotation/json_annotation.dart';

part 'thirdPartyInfo.g.dart';

@JsonSerializable(explicitToJson: true)
class ThirdPartyInfo{

  String firstName;
  String lastName;
  String address;
  String phoneNumber;
  String registrationNumber;
  String makeAndModel;
  String insurer;
  String damages;

  ThirdPartyInfo({this.firstName, this.lastName, this.address,this.phoneNumber,this.registrationNumber,this.makeAndModel,this.insurer,this.damages});

  factory ThirdPartyInfo.fromJson(Map<String, dynamic> json) => _$ThirdPartyInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ThirdPartyInfoToJson(this);

}