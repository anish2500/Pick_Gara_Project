import 'package:dartz/dartz.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/features/match/domain/entities/match_entity.dart';

abstract interface class IMatchRepository {
  Future<Either<Failure, List<MatchEntity>>> getCompletedRooms();
  Future<Either<Failure, Unit>> completeRoom(String roomId);
}
