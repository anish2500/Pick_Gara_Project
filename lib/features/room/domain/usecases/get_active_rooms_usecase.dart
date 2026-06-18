import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/core/usecases/usecase.dart';
import 'package:mero_choice_application/features/room/data/repositories/room_repository.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_entity.dart';
import 'package:mero_choice_application/features/room/domain/repositories/room_repository.dart';

final getActiveRoomsUsecaseProvider = Provider<GetActiveRoomsUsecase>((ref) {
  return GetActiveRoomsUsecase(roomRepository: ref.read(roomRepositoryProvider));
});

class GetActiveRoomsUsecase implements UsecaseWithoutParams<List<RoomEntity>> {
  final IRoomRepository _roomRepository;

  GetActiveRoomsUsecase({required IRoomRepository roomRepository})
      : _roomRepository = roomRepository;

  @override
  Future<Either<Failure, List<RoomEntity>>> call() {
    return _roomRepository.getActiveRooms();
  }
}
