import 'package:json_annotation/json_annotation.dart';
import 'package:mero_choice_application/features/match/domain/entities/match_entity.dart';
import 'package:mero_choice_application/features/place/data/models/place_api_model.dart';

part 'match_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MatchApiModel {
  @JsonKey(name: '_id')
  final String roomId;

  @JsonKey(name: 'name')
  final String roomName;

  final String category;

  @JsonKey(name: 'winnerId')
  final PlaceApiModel winner;

  @JsonKey(name: 'updatedAt')
  final DateTime completedAt;

  const MatchApiModel({
    required this.roomId,
    required this.roomName,
    required this.category,
    required this.winner,
    required this.completedAt,
  });

  factory MatchApiModel.fromJson(Map<String, dynamic> json) =>
      _$MatchApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchApiModelToJson(this);

  MatchEntity toEntity() => MatchEntity(
        roomId: roomId,
        roomName: roomName,
        category: category,
        winner: winner.toEntity(),
        completedAt: completedAt,
      );
}
