import 'package:equatable/equatable.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';

class MatchEntity extends Equatable {
  final String roomId;
  final String roomName;
  final String category;
  final String hostId; 
  final PlaceEntity winner;
  final DateTime completedAt;

  const MatchEntity({
    required this.roomId,
    required this.roomName,
    required this.category,
    required this.hostId, 
    required this.winner,
    required this.completedAt,
  });

  @override
  List<Object?> get props => [roomId, roomName, category,hostId,  winner, completedAt];
}
