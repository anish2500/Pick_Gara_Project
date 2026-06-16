

import 'package:dartz/dartz.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/features/vote/domain/entities/vote_entity.dart';

abstract interface class IVoteRepository {
  Future<Either<Failure, VoteStatsEntity>> castVote( String roomId, String placeId, VoteType voteType); 
}