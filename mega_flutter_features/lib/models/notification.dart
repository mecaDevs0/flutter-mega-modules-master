import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class NotificationModel {
  String? title;
  String? content;
  int? dateRead;
  int? created;
  String? date;
  String? id;

  NotificationModel({
    this.title,
    this.content,
    this.dateRead,
    this.created,
    this.id,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
