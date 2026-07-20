import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/features/friend/domain/usecases/get_friends_usecase.dart';
import 'package:mero_choice_application/features/friend/presentation/state/friend_state.dart';

final friendViewModelProvider =
    NotifierProvider<FriendViewModel, FriendState>(FriendViewModel.new);

class FriendViewModel extends Notifier<FriendState> {
  @override
  FriendState build() => FriendState.initial();

  Future<void> loadFriends() async {
    if (state.status == FriendStatus.loading) return;
    state = state.copyWith(status: FriendStatus.loading);
    final result = await ref.read(getFriendsUsecaseProvider).call();
    result.fold(
      (failure) => state = state.copyWith(
        status: FriendStatus.error,
        errorMessage: failure.message,
      ),
      (data) => state = state.copyWith(
        status: FriendStatus.loaded,
        friends: data.friends,
        totalFriends: data.stats.totalFriends,
        totalSharedActivities: data.stats.totalSharedActivities,
      ),
    );
  }
}
