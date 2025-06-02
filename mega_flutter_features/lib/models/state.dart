import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

@JsonSerializable()
class StateModel {
  String? name;
  String? uf;
  String? id;

  StateModel({this.name, this.uf, this.id});

  factory StateModel.fromJson(Map<String, dynamic> json) =>
      _$StateModelFromJson(json);
  Map<String, dynamic> toJson() => _$StateModelToJson(this);
}
