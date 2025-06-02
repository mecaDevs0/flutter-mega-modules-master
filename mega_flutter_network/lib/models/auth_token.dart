import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_token.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class AuthToken {
  @HiveField(0)
  @JsonKey(name: 'access_token')
  String? accessToken;
  @HiveField(1)
  @JsonKey(name: 'refresh_token')
  String? refreshToken;
  @HiveField(2)
  @JsonKey(name: 'expires_in')
  int? expiresIn;
  @HiveField(3)
  String? expires;
  @HiveField(4)
  @JsonKey(name: 'expires_type')
  String? expiresType;

  AuthToken({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.expires,
    this.expiresType,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);
  Map<String, dynamic> toJson() => _$AuthTokenToJson(this);
}
