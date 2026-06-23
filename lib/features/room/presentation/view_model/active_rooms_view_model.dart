import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_detail_entity.dart';
import 'package:mero_choice_application/features/room/domain/usecases/get_active_rooms_usecase.dart';
import 'package:mero_choice_application/features/room/domain/usecases/get_room_detail_usecase.dart';
import 'package:mero_choice_application/features/room/presentation/state/active_rooms_state.dart';

final activeRoomsViewModelProvider =
    NotifierProvider<ActiveRoomsViewModel, ActiveRoomsState>(
  ActiveRoomsViewModel.new,
);

class ActiveRoomsViewModel extends Notifier<ActiveRoomsState> {
  @override
  ActiveRoomsState build() => ActiveRoomsState.initial();

  Future<void> loadActiveRooms() async {
    state = state.copyWith(status: ActiveRoomsStatus.loading);

    // 1. Get current user ID from auth state
    final currentUserId =
        ref.read(authViewModelProvider).authEntity?.authId ?? '';

    // 2. Fetch all active rooms the user is part of
    final listResult = await ref.read(getActiveRoomsUsecaseProvider).call();

    final rooms = listResult.fold<dynamic>((l) => null, (r) => r);
    if (rooms == null) {
      final msg = listResult.fold((l) => l.message, (_) => 'Error');
      state = state.copyWith(
        status: ActiveRoomsStatus.error,
        errorMessage: msg,
      );
      return;
    }

    // 3. Split into host rooms (created by user) and member rooms (joined)
    final allRooms = rooms as List;
    final rawHostRooms = allRooms
        .where((r) => r.hostId == currentUserId)
        .toList();
    final rawMemberRooms = allRooms
        .where((r) => r.hostId != currentUserId && r.hostId.isNotEmpty)
        .toList();

    // 4. Fetch full detail for each room (to get voteStats.placeTallies)
    Future<List<RoomDetailEntity>> fetchDetails(List rooms) async {
      if (rooms.isEmpty) return [];
      final results = await Future.wait(
        rooms.map(
          (r) => ref.read(getRoomDetailUsecaseProvider).call(
                GetRoomDetailParams(roomId: r.roomId!),
              ),
        ),
      );
      final details = <RoomDetailEntity>[];
      for (final res in results) {
        res.fold((_) {}, (d) => details.add(d));
      }
      return details;
    }

    final hostDetails = await fetchDetails(rawHostRooms);
    final memberDetails = await fetchDetails(rawMemberRooms);

    state = state.copyWith(
      status: ActiveRoomsStatus.loaded,
      hostRooms: hostDetails,
      memberRooms: memberDetails,
    );
  }

  void reset() => state = ActiveRoomsState.initial();
}
