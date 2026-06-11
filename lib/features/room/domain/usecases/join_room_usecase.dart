import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/core/usecases/usecase.dart';
import 'package:mero_choice_application/features/room/data/repositories/room_repository.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_entity.dart';
import 'package:mero_choice_application/features/room/domain/repositories/room_repository.dart';

final joinRoomUsecaseProvider = Provider<JoinRoomUsecase>((ref) {
  return JoinRoomUsecase(roomRepository: ref.read(roomRepositoryProvider));
});

class JoinRoomUsecaseParams extends Equatable {
  final String pin;

  const JoinRoomUsecaseParams({required this.pin});

  @override
  List<Object?> get props => [pin];
}

class JoinRoomUsecase
    implements UsecaseWithParams<RoomEntity, JoinRoomUsecaseParams> {
  final IRoomRepository _roomRepository;

  JoinRoomUsecase({required IRoomRepository roomRepository})
    : _roomRepository = roomRepository;

  @override
  Future<Either<Failure, RoomEntity>> call(JoinRoomUsecaseParams params) {
    return _roomRepository.joinRoom(params.pin); 
  }
}
