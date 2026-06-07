import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/room_entity.dart';
import '../repositories/room_repository.dart';
import '../../data/repositories/room_repository.dart';

final createRoomUsecaseProvider = Provider<CreateRoomUsecase>((ref) {
  return CreateRoomUsecase(roomRepository: ref.read(roomRepositoryProvider));
});

class CreateRoomUsecaseParams extends Equatable {
  final String name;
  final String category;

  const CreateRoomUsecaseParams({required this.name, required this.category});

  @override
  List<Object?> get props => [name, category];
}

class CreateRoomUsecase
    implements UsecaseWithParams<RoomEntity, CreateRoomUsecaseParams> {
  final IRoomRepository _roomRepository;

  CreateRoomUsecase({required IRoomRepository roomRepository})
      : _roomRepository = roomRepository;

  @override
  Future<Either<Failure, RoomEntity>> call(CreateRoomUsecaseParams params) {
    return _roomRepository.createRoom(params.name, params.category);
  }
}
