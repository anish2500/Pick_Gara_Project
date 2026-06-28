import 'package:equatable/equatable.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_detail_entity.dart';
import 'package:mero_choice_application/features/vote/domain/entities/vote_entity.dart';

enum SwipeStatus { initial, loading, loaded, error, completed }

class SwipeSessionState extends Equatable {
  final SwipeStatus status;
  final RoomDetailEntity? detail;
  final VoteStatsEntity? voteStats;
  final bool isSubmittingVote;
  final int currentIndex;
  final List<String> likedPlaceIds;
  final List<String> dislikedPlaceIds;
  final String? errorMessage;
  final bool hasSuperVote; 

  const SwipeSessionState({
    required this.status,
    this.detail,
    this.voteStats,
    this.isSubmittingVote = false,
    this.currentIndex = 0,
    this.likedPlaceIds = const [],
    this.dislikedPlaceIds = const [],
    this.errorMessage,
    this.hasSuperVote = false, 
  });

  factory SwipeSessionState.initial() =>
      const SwipeSessionState(status: SwipeStatus.initial);

  bool get hasCards => detail != null && currentIndex < detail!.places.length;

  PlaceEntity? get currentPlace =>
      hasCards ? detail!.places[currentIndex] : null;

  SwipeSessionState copyWith({
    SwipeStatus? status,
    RoomDetailEntity? detail,
    VoteStatsEntity? voteStats,
    bool? isSubmittingVote,
    int? currentIndex,
    List<String>? likedPlaceIds,
    List<String>? dislikedPlaceIds,
    String? errorMessage,
    bool? hasSuperVote, 
  }) {
    return SwipeSessionState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      voteStats: voteStats ?? this.voteStats,
      isSubmittingVote: isSubmittingVote ?? this.isSubmittingVote,
      currentIndex: currentIndex ?? this.currentIndex,
      likedPlaceIds: likedPlaceIds ?? this.likedPlaceIds,
      dislikedPlaceIds: dislikedPlaceIds ?? this.dislikedPlaceIds,
      errorMessage: errorMessage ?? this.errorMessage,
      hasSuperVote: hasSuperVote ?? this.hasSuperVote
    );
  }

  @override
  List<Object?> get props => [
    status,
    detail,
    voteStats,
    isSubmittingVote,
    currentIndex,
    likedPlaceIds,
    dislikedPlaceIds,
    errorMessage,
    hasSuperVote
  ];
}
