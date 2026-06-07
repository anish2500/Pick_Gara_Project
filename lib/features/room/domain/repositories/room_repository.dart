import 'package:dartz/dartz.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_entity.dart';

abstract interface class IRoomRepository {
  Future<Either<Failure, RoomEntity>> createRoom(String name, String category); 
}
