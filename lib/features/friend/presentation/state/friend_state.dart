import 'package:equatable/equatable.dart';
import 'package:mero_choice_application/features/friend/domain/entities/friend_entity.dart';

enum FriendStatus { initial, loading, loaded, error }

class FriendState extends Equatable {
  final FriendStatus status;
  final List<FriendEntity> friends;
  final int totalFriends;
  final int totalSharedActivities;
  final String? errorMessage;

  const FriendState({
    required this.status,
    this.friends = const [],
    this.totalFriends = 0,
    this.totalSharedActivities = 0,
    this.errorMessage,
  });

  factory FriendState.initial() =>
      const FriendState(status: FriendStatus.initial);

  FriendState copyWith({
    FriendStatus? status,
    List<FriendEntity>? friends,
    int? totalFriends,
    int? totalSharedActivities,
    String? errorMessage,
  }) {
    return FriendState(
      status: status ?? this.status,
      friends: friends ?? this.friends,
      totalFriends: totalFriends ?? this.totalFriends,
      totalSharedActivities:
          totalSharedActivities ?? this.totalSharedActivities,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    friends,
    totalFriends,
    totalSharedActivities,
    errorMessage,
  ];
}
