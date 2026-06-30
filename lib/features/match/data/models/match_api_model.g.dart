// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchApiModel _$MatchApiModelFromJson(Map<String, dynamic> json) =>
    MatchApiModel(
      roomId: json['_id'] as String,
      roomName: json['name'] as String,
      category: json['category'] as String,
      winner: PlaceApiModel.fromJson(json['winnerId'] as Map<String, dynamic>),
      completedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MatchApiModelToJson(MatchApiModel instance) =>
    <String, dynamic>{
      '_id': instance.roomId,
      'name': instance.roomName,
      'category': instance.category,
      'winnerId': instance.winner.toJson(),
      'updatedAt': instance.completedAt.toIso8601String(),
    };
