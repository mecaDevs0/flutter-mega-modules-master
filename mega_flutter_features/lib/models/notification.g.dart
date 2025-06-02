// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      title: json['title'] as String?,
      content: json['content'] as String?,
      dateRead: json['dateRead'] as int?,
      created: json['created'] as int?,
      id: json['id'] as String?,
    )..date = json['date'] as String?;

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'dateRead': instance.dateRead,
      'created': instance.created,
      'date': instance.date,
      'id': instance.id,
    };
