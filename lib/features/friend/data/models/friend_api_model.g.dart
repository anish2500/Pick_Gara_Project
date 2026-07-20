// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendApiModel _$FriendApiModelFromJson(Map<String, dynamic> json) =>
    FriendApiModel(
      userId: json['_id'] as String,
      fullName: json['fullName'] as String,
      profileImage: json['profileImage'] as String?,
      sharedActivities: (json['sharedActivities'] as num).toInt(),
    );

Map<String, dynamic> _$FriendApiModelToJson(FriendApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'fullName': instance.fullName,
      'profileImage': instance.profileImage,
      'sharedActivities': instance.sharedActivities,
    };
