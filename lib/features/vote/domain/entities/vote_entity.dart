import 'package:equatable/equatable.dart';

enum VoteType { like, dislike, superlike }

class PlaceTallyEntity extends Equatable {
  final String placeId;
  final int likes;
  final int dislikes;
  final int total;

  const PlaceTallyEntity({
    required this.placeId,
    required this.likes,
    required this.dislikes,
    required this.total,
  });

  @override
  List<Object?> get props => [placeId, likes, dislikes, total];
}

class VoteStatsEntity extends Equatable {
  final int membersVoted;
  final int totalMembers;
  final String display;
  final List<PlaceTallyEntity> placeTallies;
  final bool hasSuperVote;

  const VoteStatsEntity({
    required this.membersVoted,
    required this.totalMembers,
    required this.display,
    this.placeTallies = const [],
    this.hasSuperVote = false,
  });

  @override
  List<Object?> get props => [membersVoted, totalMembers, display, placeTallies, hasSuperVote];
}
