import 'package:json_annotation/json_annotation.dart';
import 'package:mero_choice_application/features/auth/domain/entities/auth_entity.dart';

part 'auth_api_model.g.dart';

@JsonSerializable()
class AuthApiModel {
  @JsonKey(name: 'id')
  final String? authId;

  final String fullName;
  final String email;
  final String? password;

  AuthApiModel({
    this.authId,
    required this.fullName,
    required this.email,
    this.password,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  AuthEntity toEntity() {
    return AuthEntity(authId: authId, fullName: fullName, email: email);
  }

  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      authId: entity.authId,
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
    ); 
  }
}
