// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      cityId: json['cityId'] as String?,
      cityName: json['cityName'] as String?,
      complement: json['complement'] as String?,
      name: json['name'] as String?,
      neighborhood: json['neighborhood'] as String?,
      number: json['number'] as String?,
      stateId: json['stateId'] as String?,
      stateName: json['stateName'] as String?,
      stateUf: json['stateUf'] as String?,
      streetAddress: json['streetAddress'] as String?,
      zipCode: json['zipCode'] as String?,
      ibge: json['ibge'] as String?,
      gia: json['gia'] as String?,
      id: json['id'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'cityId': instance.cityId,
      'cityName': instance.cityName,
      'complement': instance.complement,
      'name': instance.name,
      'neighborhood': instance.neighborhood,
      'number': instance.number,
      'stateId': instance.stateId,
      'stateName': instance.stateName,
      'stateUf': instance.stateUf,
      'streetAddress': instance.streetAddress,
      'zipCode': instance.zipCode,
      'ibge': instance.ibge,
      'gia': instance.gia,
      'id': instance.id,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
