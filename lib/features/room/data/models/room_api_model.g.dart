// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomApiModel _$RoomApiModelFromJson(Map<String, dynamic> json) => RoomApiModel(
  roomId: json['_id'] as String?,
  name: json['name'] as String,
  category: json['category'] as String,
  pin: json['pin'] as String?,
  hostId: json['hostId'] as String?,
  members: (json['members'] as List<dynamic>).map((e) => e as String).toList(),
  status: json['status'] as String?,
);

Map<String, dynamic> _$RoomApiModelToJson(RoomApiModel instance) =>
    <String, dynamic>{
      '_id': instance.roomId,
      'name': instance.name,
      'category': instance.category,
      'pin': instance.pin,
      'hostId': instance.hostId,
      'members': instance.members,
      'status': instance.status,
    };
