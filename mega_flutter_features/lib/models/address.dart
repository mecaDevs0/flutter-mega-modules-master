import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  String? cityId;
  String? cityName;
  String? complement;
  String? name;
  String? neighborhood;
  String? number;
  String? stateId;
  String? stateName;
  String? stateUf;
  String? streetAddress;
  String? zipCode;
  String? ibge;
  String? gia;
  String? id;
  double? latitude;
  double? longitude;

  Address({
    this.cityId,
    this.cityName,
    this.complement,
    this.name,
    this.neighborhood,
    this.number,
    this.stateId,
    this.stateName,
    this.stateUf,
    this.streetAddress,
    this.zipCode,
    this.ibge,
    this.gia,
    this.id,
    this.latitude,
    this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
