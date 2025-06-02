import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable()
class Country {
  String? name;
  String? flag;
  String? id;

  Country({this.name, this.flag, this.id});

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);

  factory Country.brazil() => Country(
        id: '5eaca770321b5f56b079ad5b',
      );
}
