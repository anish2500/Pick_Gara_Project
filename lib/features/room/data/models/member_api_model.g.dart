// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberApiModel _$MemberApiModelFromJson(Map<String, dynamic> json) =>
    MemberApiModel(
      memberId: json['_id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$MemberApiModelToJson(MemberApiModel instance) =>
    <String, dynamic>{
      '_id': instance.memberId,
      'fullName': instance.fullName,
      'email': instance.email,
    };
