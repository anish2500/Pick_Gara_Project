import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/core/usecases/usecase.dart';
import 'package:mero_choice_application/features/room/data/repositories/room_repository.dart';
import 'package:mero_choice_application/features/room/domain/repositories/room_repository.dart';

final deleteRoomUsecaseProvider = Provider<DeleteRoomUsecase>((ref) {
  return DeleteRoomUsecase(roomRepository: ref.read(roomRepositoryProvider));
});

class DeleteRoomParams extends Equatable {
  final String roomId;
  const DeleteRoomParams({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}

class DeleteRoomUsecase implements UsecaseWithParams<Unit, DeleteRoomParams> {
  final IRoomRepository _roomRepository;

  DeleteRoomUsecase({required IRoomRepository roomRepository})
      : _roomRepository = roomRepository;

  @override
  Future<Either<Failure, Unit>> call(DeleteRoomParams params) {
    return _roomRepository.deleteRoom(params.roomId);
  }
}
