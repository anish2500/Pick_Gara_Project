import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/core/usecases/usecase.dart';
import 'package:mero_choice_application/features/match/data/repositories/match_repository.dart';
import 'package:mero_choice_application/features/match/domain/entities/match_entity.dart';
import 'package:mero_choice_application/features/match/domain/repositories/match_repository.dart';

final getMatchesUsecaseProvider = Provider<GetMatchesUsecase>((ref) {
  return GetMatchesUsecase(ref.read(matchRepositoryProvider));
});

class GetMatchesUsecase implements UsecaseWithoutParams<List<MatchEntity>> {
  final IMatchRepository _repo;
  GetMatchesUsecase(this._repo);

  @override
  Future<Either<Failure, List<MatchEntity>>> call() =>
      _repo.getCompletedRooms();
}
