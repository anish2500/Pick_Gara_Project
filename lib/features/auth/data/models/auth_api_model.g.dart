// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthApiModel _$AuthApiModelFromJson(Map<String, dynamic> json) => AuthApiModel(
  authId: json['id'] as String?,
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  password: json['password'] as String?,
  profileImage: json['profileImage'] as String?,
);

Map<String, dynamic> _$AuthApiModelToJson(AuthApiModel instance) =>
    <String, dynamic>{
      'id': instance.authId,
      'fullName': instance.fullName,
      'email': instance.email,
      'password': instance.password,
      'profileImage': instance.profileImage,
    };
