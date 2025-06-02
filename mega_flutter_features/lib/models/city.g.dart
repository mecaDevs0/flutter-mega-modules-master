// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) => City(
      name: json['name'] as String?,
      stateName: json['stateName'] as String?,
      stateId: json['stateId'] as String?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'name': instance.name,
      'stateName': instance.stateName,
      'stateId': instance.stateId,
      'id': instance.id,
    };
