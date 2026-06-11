import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/core/usecases/usecase.dart';
import 'package:mero_choice_application/features/room/data/repositories/room_repository.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_detail_entity.dart';
import 'package:mero_choice_application/features/room/domain/repositories/room_repository.dart';

final getRoomDetailUsecaseProvider = Provider<GetRoomDetailUsecase>((ref) {
  return GetRoomDetailUsecase(roomRepository: ref.read(roomRepositoryProvider));
});

class GetRoomDetailParams extends Equatable {
  final String roomId;
  const GetRoomDetailParams({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}

class GetRoomDetailUsecase
    implements UsecaseWithParams<RoomDetailEntity, GetRoomDetailParams> {
  final IRoomRepository _roomRepository;

  GetRoomDetailUsecase({required IRoomRepository roomRepository})
      : _roomRepository = roomRepository;

  @override
  Future<Either<Failure, RoomDetailEntity>> call(GetRoomDetailParams params) {
    return _roomRepository.getRoomDetail(params.roomId);
  }
}
