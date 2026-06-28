import 'package:equatable/equatable.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_entity.dart';
import 'package:mero_choice_application/features/vote/domain/entities/vote_entity.dart';

class RoomDetailEntity extends Equatable {
  final RoomEntity room;
  final List<PlaceEntity> places;
  final int memberCount;
  final VoteStatsEntity? voteStats;
  final bool hasSuperVote;

  const RoomDetailEntity({
    required this.room,
    required this.places,
    required this.memberCount,
    this.voteStats,
    this.hasSuperVote = false,
  });

  @override
  List<Object?> get props => [room, places, memberCount, voteStats, hasSuperVote];
}
