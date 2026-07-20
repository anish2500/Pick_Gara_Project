import 'package:json_annotation/json_annotation.dart';
import 'package:mero_choice_application/features/friend/domain/entities/friend_entity.dart';

part 'friend_api_model.g.dart';

@JsonSerializable()
class FriendApiModel {
  @JsonKey(name: '_id')
  final String userId;
  final String fullName;
  final String? profileImage;
  final int sharedActivities;

  const FriendApiModel({
    required this.userId,
    required this.fullName,
    this.profileImage,
    required this.sharedActivities,
  });

  factory FriendApiModel.fromJson(Map<String, dynamic> json) =>
      _$FriendApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$FriendApiModelToJson(this);

  FriendEntity toEntity() => FriendEntity(
    userId: userId,
    fullName: fullName,
    sharedActivities: sharedActivities,
  );
  
}
