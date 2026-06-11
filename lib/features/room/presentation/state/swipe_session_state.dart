import 'package:equatable/equatable.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_detail_entity.dart';

enum SwipeStatus { initial, loading, loaded, error, completed }

class SwipeSessionState extends Equatable {
  final SwipeStatus status;
  final RoomDetailEntity? detail;

  final int currentIndex;
  final List<String> likedPlaceIds;
  final List<String> dislikedPlaceIds;
  final String? errorMessage;

  const SwipeSessionState({
    required this.status,
    this.detail,
    this.currentIndex = 0,
    this.likedPlaceIds = const [],
    this.dislikedPlaceIds = const [], 
    this.errorMessage,
  });

  factory SwipeSessionState.initial() =>
      const SwipeSessionState(status: SwipeStatus.initial);

  bool get hasCards => detail != null && currentIndex < detail!.places.length;

  PlaceEntity? get currentPlace =>
      hasCards ? detail!.places[currentIndex] : null; 


  SwipeSessionState copyWith({
    SwipeStatus? status, 
    RoomDetailEntity? detail,
    int? currentIndex, 
    List<String>? likedPlaceIds, 
    List<String>? dislikedPlaceIds, 
    String? errorMessage, 


  })    {

return SwipeSessionState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      currentIndex: currentIndex ?? this.currentIndex,
      likedPlaceIds: likedPlaceIds ?? this.likedPlaceIds,
      dislikedPlaceIds: dislikedPlaceIds ?? this.dislikedPlaceIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override   
  List<Object?> get props => [status, detail, currentIndex, likedPlaceIds, dislikedPlaceIds, errorMessage];   
}
