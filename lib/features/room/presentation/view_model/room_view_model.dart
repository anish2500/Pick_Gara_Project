import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/features/room/domain/usecases/create_room_usecase.dart';
import 'package:mero_choice_application/features/room/domain/usecases/join_room_usecase.dart';
import 'package:mero_choice_application/features/room/presentation/state/room_state.dart';

final roomViewModelProvider = NotifierProvider<RoomViewModel, RoomState>(
  RoomViewModel.new,
);

class RoomViewModel extends Notifier<RoomState> {
  @override
  RoomState build() => RoomState.initial();

  Future<void> createRoom(String name, String category) async {
    state = state.copyWith(status: RoomStatus.loading);

    final result = await ref
        .read(createRoomUsecaseProvider)
        .call(CreateRoomUsecaseParams(name: name, category: category));

    result.fold(
      (failure) => state = state.copyWith(
        status: RoomStatus.error,
        errorMessage: failure.message,
      ),
      (room) => state = state.copyWith(status: RoomStatus.success, room: room),
    );
  }

  Future<void> joinRoom(String pin) async {
    state = state.copyWith(status: RoomStatus.loading);

    final result = await ref
        .read(joinRoomUsecaseProvider)
        .call(JoinRoomUsecaseParams(pin: pin));
    result.fold(
      (failure) => state = state.copyWith(
        status: RoomStatus.error,
        errorMessage: failure.message,
      ),
      (room) => state = state.copyWith(status: RoomStatus.success, room: room),
    );
  }

  void resetState() => state = RoomState.initial();
}
