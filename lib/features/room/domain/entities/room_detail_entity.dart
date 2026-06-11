import 'package:equatable/equatable.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_entity.dart';

class RoomDetailEntity extends Equatable {
  final RoomEntity room;

  final List<PlaceEntity> places;
  final int memberCount;

  const RoomDetailEntity({
    required this.room,
    required this.places,
    required this.memberCount,
  });

  @override
  List<Object?> get props => [room, places, memberCount]; 
}
