import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/features/room/domain/usecases/get_room_detail_usecase.dart';
import 'package:mero_choice_application/features/room/presentation/state/swipe_session_state.dart';

final swipeSessionViewModelProvider =
    NotifierProvider<SwipeSessionViewModel, SwipeSessionState>(
  SwipeSessionViewModel.new,
);

class SwipeSessionViewModel extends Notifier<SwipeSessionState> {
  @override
  SwipeSessionState build() => SwipeSessionState.initial();

  Future<void> loadRoom(String roomId) async {
    state = state.copyWith(status: SwipeStatus.loading);
    final result = await ref
        .read(getRoomDetailUsecaseProvider)
        .call(GetRoomDetailParams(roomId: roomId));
    result.fold(
      (failure) => state = state.copyWith(
        status: SwipeStatus.error,
        errorMessage: failure.message,
      ),
      (detail) => state = state.copyWith(
        status: SwipeStatus.loaded,
        detail: detail,
        currentIndex: 0,
      ),
    );
  }

  void swipeLike() => _advance(liked: true);
  void swipeDislike() => _advance(liked: false);
  void swipeSkip() => _advance(liked: null);

  void _advance({bool? liked}) {
    final place = state.currentPlace;
    if (place == null) return;

    final newLiked = List<String>.from(state.likedPlaceIds);
    final newDisliked = List<String>.from(state.dislikedPlaceIds);

    if (liked == true) newLiked.add(place.placeId);
    if (liked == false) newDisliked.add(place.placeId);

    final nextIndex = state.currentIndex + 1;
    final isLast = nextIndex >= (state.detail?.places.length ?? 0);

    state = state.copyWith(
      currentIndex: nextIndex,
      likedPlaceIds: newLiked,
      dislikedPlaceIds: newDisliked,
      status: isLast ? SwipeStatus.completed : SwipeStatus.loaded,
    );
  }

  void resetState() => state = SwipeSessionState.initial();
}
