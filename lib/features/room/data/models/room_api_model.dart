import 'package:json_annotation/json_annotation.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_entity.dart';

part 'room_api_model.g.dart';

@JsonSerializable()
class RoomApiModel {
  @JsonKey(name: '_id')
  final String? roomId;
  final String name;
  final String category;
  final String? pin;
  final String? hostId;
  final List<String> members;
  final String? status;
  final String? createdAt; 

  RoomApiModel({
    this.roomId,
    required this.name,
    required this.category,
    this.pin,
    this.hostId,
    required this.members,
    this.status,
    this.createdAt, 
  });

  factory RoomApiModel.fromJson(Map<String, dynamic> json) =>
      _$RoomApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoomApiModelToJson(this);

  RoomEntity toEntity() {
    return RoomEntity(
      roomId: roomId,
      name: name,
      category: category,
      pin: pin ?? '',
      hostId: hostId ?? '',
      members: members,
      status: status ?? 'active',
      createdAt: createdAt !=null ? DateTime.tryParse(createdAt!) : null, 
    );
  }
}
