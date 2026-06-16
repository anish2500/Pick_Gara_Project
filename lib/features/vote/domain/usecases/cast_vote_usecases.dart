import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/core/usecases/usecase.dart';
import 'package:mero_choice_application/features/vote/data/repositories/vote_respository.dart';

import 'package:mero_choice_application/features/vote/domain/entities/vote_entity.dart';
import 'package:mero_choice_application/features/vote/domain/repositories/vote_repository.dart';

final castVoteUsecaseProvider = Provider<CastVoteUsecases>((ref) {
  return CastVoteUsecases(voteRepository: ref.read(voteRepositoryProvider));
});

class CastVoteParams extends Equatable {
  final String roomId;
  final String placeId;
  final VoteType voteType;

  const CastVoteParams({
    required this.roomId,
    required this.placeId,
    required this.voteType,
  });

  @override
  List<Object?> get props => [roomId, placeId, voteType];
}

class CastVoteUsecases
    implements UsecaseWithParams<VoteStatsEntity, CastVoteParams> {
  final IVoteRepository _voteRepository;

  CastVoteUsecases({required IVoteRepository voteRepository})
      : _voteRepository = voteRepository;

  @override
  Future<Either<Failure, VoteStatsEntity>> call(CastVoteParams params) {
    return _voteRepository.castVote(
      params.roomId,
      params.placeId,
      params.voteType,
    );
  }
}
