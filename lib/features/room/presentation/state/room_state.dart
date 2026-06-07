import 'package:equatable/equatable.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_entity.dart';

enum RoomStatus { initial, loading, success, error }

class RoomState extends Equatable {
  final RoomStatus status;
  final RoomEntity? room;
  final String? errorMessage;

  const RoomState({
    required this.status,
    this.room,
    this.errorMessage,
  });

  factory RoomState.initial() {
    return const RoomState(status: RoomStatus.initial);
  }

  RoomState copyWith({
    RoomStatus? status,
    RoomEntity? room,
    String? errorMessage,
  }) {
    return RoomState(
      status: status ?? this.status,
      room: room ?? this.room,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, room, errorMessage];
}
