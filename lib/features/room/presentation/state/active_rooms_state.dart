import 'package:equatable/equatable.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_detail_entity.dart';

enum ActiveRoomsStatus { initial, loading, loaded, error }

class ActiveRoomsState extends Equatable {
  final ActiveRoomsStatus status;
  final List<RoomDetailEntity> memberRooms; // rooms user joined (not host)
  final List<RoomDetailEntity> hostRooms;   // rooms user created
  final String? errorMessage;

  const ActiveRoomsState({
    required this.status,
    this.memberRooms = const [],
    this.hostRooms = const [],
    this.errorMessage,
  });

  factory ActiveRoomsState.initial() =>
      const ActiveRoomsState(status: ActiveRoomsStatus.initial);

  ActiveRoomsState copyWith({
    ActiveRoomsStatus? status,
    List<RoomDetailEntity>? memberRooms,
    List<RoomDetailEntity>? hostRooms,
    String? errorMessage,
  }) {
    return ActiveRoomsState(
      status: status ?? this.status,
      memberRooms: memberRooms ?? this.memberRooms,
      hostRooms: hostRooms ?? this.hostRooms,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, memberRooms, hostRooms, errorMessage];
}
