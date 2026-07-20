import 'package:equatable/equatable.dart';

class FriendStatsEntity extends Equatable {
  final int totalFriends;
  final int totalSharedActivities;

  const FriendStatsEntity({
    required this.totalFriends,
    required this.totalSharedActivities,
  });

  @override
  List<Object?> get props => [totalFriends, totalSharedActivities];
}

class FriendEntity extends Equatable {
  final String userId;
  final String fullName;
  final String? profileImage;
  final int sharedActivities;

  const FriendEntity({
    required this.userId,
    required this.fullName,
    this.profileImage,
    required this.sharedActivities,
  });

  @override
  List<Object?> get props => [userId, fullName, profileImage, sharedActivities];
}

class FriendListResult extends Equatable {
  final FriendStatsEntity stats;
  final List<FriendEntity> friends;

  const FriendListResult({required this.stats, required this.friends});

  @override
  List<Object?> get props => [stats, friends];
}
