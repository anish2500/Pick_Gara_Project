import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/error/failures.dart';
import 'package:mero_choice_application/features/vote/data/datasources/remote/vote_remote_datasource.dart';
import 'package:mero_choice_application/features/vote/domain/entities/vote_entity.dart';
import 'package:mero_choice_application/features/vote/domain/repositories/vote_repository.dart';

final voteRepositoryProvider = Provider<IVoteRepository>((ref) {
  return VoteRepository(
    remoteDatasource: ref.read(voteRemoteDatasourceProvider),
  );
});

class VoteRepository implements IVoteRepository {
  final VoteRemoteDatasource _remoteDatasource;

  VoteRepository({required VoteRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, VoteStatsEntity>> castVote(
    String roomId,
    String placeId,
    VoteType voteType,
  ) async {
    try {
      final model = await _remoteDatasource.castVote(
        roomId,
        placeId,
        voteType.name, // enum → 'like' | 'dislike' | 'superlike'
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ApiFailure(
        message: (e.response?.data is Map
                ? e.response?.data['message']
                : null) ??
            e.message ??
            'Failed to cast vote',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
